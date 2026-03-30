class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://github.com/steveyegge/beads/archive/refs/tags/v0.63.3.tar.gz"
  sha256 "5a9a2330d21fca03da9c6ce1e744a9e8d9a3c889357d21f238b7eb9568828e58"
  license "MIT"
  compatibility_version 1
  head "https://github.com/steveyegge/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "057b34fb1a25ecfb8a19925eee84cbb180d740437e3db9e5fe23f9715f6ef43a"
    sha256 cellar: :any,                 arm64_sequoia: "6115e30cfdb340d47079d402343bc2bd849a2ed00d1559f8fe6d1dd10b669efa"
    sha256 cellar: :any,                 arm64_sonoma:  "dba47eee19e66394056f8f16ec1ee135532caccfb90ca99939e4cf6d947b1802"
    sha256 cellar: :any,                 sonoma:        "8e9571cfce460f1842c375a9bc925a7fb630e243995183a8673c6224cbc479d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5790f8cd8d73b61ebe6c1dd4075422d3754632509e87b570792ebd4d64e40cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c4e3eacab42abec4066bfdba2ec519d941d2a9a21ad4f3a842f7ad4f33ee34"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@78"

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Branch=#{build.head? ? "HEAD" : "v#{version}"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    shell_output("#{bin}/bd init -p homebrew-beads < /dev/null")
    assert_path_exists testpath/"AGENTS.md"
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end
