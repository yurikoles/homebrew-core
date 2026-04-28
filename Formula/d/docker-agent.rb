class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "8e97249c814f30dfdf84dabb0a7be8ff37df9bfd35d099f781c064620db1bec5"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0ea7ede58bb3dcd4421fe30d0622848f553dc753b50e00f62e8acab8dfbb00b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "873021ba94f37a22f65cbb656f519311c26db9a785a353b98eafc9f3eebed02f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7580dc9a85e06aa160645a8b85a92e6ce6e12ea4c25d94399bcd6dcde5fc26d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0df441055edc448e7a585081426b31c28d8fe5e863c37c3a946029909a8fcbe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "551fd4b4a027f225a665a85d4a51fab185153f569aa74aadd6652991319b4bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "262bb9335e3dc126a7ceb877bd389fcfdc03e976d37a99114f4a33de8202ef06"
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
