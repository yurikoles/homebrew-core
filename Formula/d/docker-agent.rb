class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "1aa89904daf3572c4c869b23291b6c318a3d78d6367bf552c5825fa22a5c90e1"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9797e4d110c10ec025c4d5f97eb6c5bf78ed989b9216eec927562b93a41991f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d2097427281a1a6c5f840716acdf01498bb97eadcf69d76432bc48e2425aa13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1f73e3470fe1b54f023a03d284ff94a77913b5c40d1c63b31eea75b9b53b4da"
    sha256 cellar: :any_skip_relocation, sonoma:        "0688339a900a6de5fc8a149d9900c22da169ff5ce6b6127ccbf97fa84f4af471"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cb098724554bd4028f94e1e039a89c762fe83cf049f5649e0b001fee0e74371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4f7a9316f419b32ac1d5c4e3f48a824ad7f640bddf1b81ea3e94a4bb44224f9"
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
