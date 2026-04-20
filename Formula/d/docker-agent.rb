class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "2e0ea927125d1c360f80bd51b06afd3b6ca53d59c1e4fa5fc3f64cfc87eec85e"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db912adbc47c8ae6b9bf496f7f7c153e36139d166a640e86a9d2028c6801be1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34ea208123b408e0b52fabc2f20cf941b17a3e9714e7dda57458d31f4750ed0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7551edb988c82c8b33ba886716e225fee6c5c045a6822072f20639893ece717"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d6f55f97d8dc51d1c00b1f04c2d9b4af149420596695ff9716d385bd62ba35e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50be8beed9ff6c379cee3c6915873ad4de9acea68e8a51825442f2d8068191ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe4c9a6ae0477f7d5d04eb728f38b1b5190b44523d26cc3f5333177cbfaec5ef"
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
