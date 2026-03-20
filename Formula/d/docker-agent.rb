class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "bc66eb8191d73ac51a3526d801decbd9f8087f9cc02a0c70d89767561d12a7bc"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01117d5eca0f95ca493ea96ec0af360682ca12eb5331664caf194048d3eba097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e7f9ee4ca3d04bb9303ea31b61d27840a3e91c6a7bb151ba8a67b45c57e7ace"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfee30cd271a1becdbcae0bdf3f50051d6ab2ed9814a7ec2cdd9f8f25cd0c10e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7ec616d607747976d694f0aa5b33696fcd80ccce58aef57d2de70a4c6f78a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c991edc3fd45fa1aa2e3fd6bfbceba346fe496014b8d664061087f4b76067399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3458e006c2f043c82d8d64a3a2a675a91c5da59559d30a9507c13c2d7f9d8c"
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
