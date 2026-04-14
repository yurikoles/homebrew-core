class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "d4ccdab2a36f487504ba0ff48bc838615776000bfa255cf1d797d0fa7a374567"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4bda7f659655dc097053e0369e242a7377f33dc046940cb1b1f9e0fee9765e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4bda7f659655dc097053e0369e242a7377f33dc046940cb1b1f9e0fee9765e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4bda7f659655dc097053e0369e242a7377f33dc046940cb1b1f9e0fee9765e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5374f4e26af8a0b545fca0398b9d21d23eaafc825d475466d401fcd29d31f5d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad7ef2b89506c1c21ee7595459e4a1ee7ef1ae875a05c69b01519e251c20b1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b22b74eea466d49f8a0661bf7c7d6fb88154647fd76ae3e7fc9def0cbc0c28f"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", shell_parameter_format: :cobra)
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

    (testpath/"buf.yaml").write <<~YAML
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - STANDARD
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    YAML

    expected = <<~EOS
      invalidFileName.proto:1:1:Filename "invalidFileName.proto" should be \
      lower_snake_case.proto, such as "invalid_file_name.proto".
      invalidFileName.proto:2:1:Files with package "examplepb" must be within \
      a directory "examplepb" relative to root but were in directory ".".
      invalidFileName.proto:2:1:Package name "examplepb" should be suffixed \
      with a correctly formed version, such as "examplepb.v1".
    EOS
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end
