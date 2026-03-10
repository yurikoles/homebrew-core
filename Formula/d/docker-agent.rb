class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "2ede2518180892ef140866495e0854076ca221cbafcdff35f212337430b2699d"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32b22bacb2c365a62fd4780db5d819a8030f269fac5a001c483a0507b61d8a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04d61dee97dd695c63ab346907fc5a655fde65e888642ee5d3eff832ffcc2a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b598a42abe40131546d64a36ee271e3a03a5624478a77591b1439cb98d8de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "84da8bc4aad7a4019dd4098d98ca31b9318b52d6f7f76db724b45a6c808dcbf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c3dd85aca0a78293f1712b53757034c19a6a5bba8f1a2b765e617de0b9eff58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b5a1269ab09c1c96ebeaf494f21a91ba1f35e8f23e3047621fbe9d2ab417cd"
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
