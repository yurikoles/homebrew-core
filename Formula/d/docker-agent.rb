class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "e07449e44d3e60923342dc84ee57a1ea9f963df4a728e30b632e21ba11961f68"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab4acc9cb18859390cbae4c4554e2cd1db84a5980dfa451d9174f73d62a28dc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd506b2fdf2e425598e0f3a58d8323f43fb41892eea58d65fbde887439e1be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f013b317001f275f14ff7926ea31c59679f57740deb74e86f6060ec6760b21d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccaec8ea75b0aff998c889a86af31c63527c4910e13e237c1d12b16c0f94db90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12a79f73a0a76a5779f930bd0f27b3e7557eea7ea10fc6ed6ecb0cc1da7ee556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12565d344e78d3272ee81068f1a49eeaa082ea5cfff1b5ad26e174d84f5bc39"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
