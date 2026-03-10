class Flagd < Formula
  desc "Feature flag daemon with a Unix philosophy"
  homepage "https://github.com/open-feature/flagd"
  url "https://github.com/open-feature/flagd.git",
      tag:      "flagd/v0.14.3",
      revision: "6bd709c8beec61bbd2b2abea65a9477074c7aaa5"
  license "Apache-2.0"
  head "https://github.com/open-feature/flagd.git", branch: "main"

  # The upstream repository contains tags like `core/v1.2.3`,
  # `flagd-proxy/v1.2.3`, etc. but we're only interested in the `flagd/v1.2.3`
  # tags. Upstream only appears to mark the `core/v1.2.3` releases as "latest"
  # and there isn't usually a notable gap between tag and release, so we check
  # the Git tags.
  livecheck do
    url :stable
    regex(%r{^flagd/v?(\d+(?:[.-]\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c92a0468a53016c737016a147ec70413c3a90fb0386476d651756672c429ccce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4d8b7d4bd25b468da4b697d165874c19812fe7db64d330cb31a1664169d7d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f66db8774db6de5fc5539923a6b6d897504e4924b2c9e3b96649a0b5872413c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0ba26ab8d8439b6fb9469048b9cfcdf304ea7f7b9c5336f7ff70b6c4cc36548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2eef1273741bf1e1fef9bed23777d299f386d46c55197f07065c15888c507a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "557d839a8f41b530f96a194d63ced4dabb555c25dbe132e4520ccfc74a930802"
  end

  depends_on "go" => :build

  def install
    ENV["GOPRIVATE"] = "buf.build/gen/go"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]

    system "make", "workspace-init"
    system "go", "build", *std_go_args(ldflags:), "./flagd/main.go"
    generate_completions_from_executable(bin/"flagd", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    json_url = "https://raw.githubusercontent.com/open-feature/flagd/main/config/samples/example_flags.json"
    resolve_boolean_command = <<~BASH
      curl \
      --request POST \
      --data '{"flagKey":"myBoolFlag","context":{}}' \
      --header "Content-Type: application/json" \
      localhost:#{port}/schema.v1.Service/ResolveBoolean
    BASH

    pid = spawn bin/"flagd", "start", "-f", json_url, "-p", port.to_s
    begin
      sleep 3
      assert_match(/true/, shell_output(resolve_boolean_command))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
