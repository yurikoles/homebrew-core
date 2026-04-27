class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "84439ac02e9239a3706daafb9a882dabe0d7b5927b33c34cae51958676edc610"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "844eb4fb331a40684bb4001e3d7d279ab9543f13dc63a4799e70d6eabc5fe820"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f5d6280429e6c920f65ed02c04dc20ba265a51ba0a75e632aea2b97140a3686"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "146a0accf0c204faa881cf5ff3194d42cc6d57d5c3004dfb424acdce5088745e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b2e779ef91688f0a5d6462656408b7cdc1395b20c4deb548ff707024ff9ea6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45a46ed666ed42f15ea7600dd5c548137916c2ff81ba2f6cd6acdcdaf77b7249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d24aea15aef37bdcec39f1a301ee0908e1f8d6cb169ee4d2933b6e999c096c"
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
