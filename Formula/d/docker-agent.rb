class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "8cfeefa321f8e658167954090d5c03e0d935e4108f1efd0e221b995ecd9aa7c4"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75e5f43e9973b3b92710fe117529bf0836eca03dcc1204a6d1de720e5fa2db98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9126af57ffca9f41113d730bdeb8825adbe4496a022a7f0bad3bdc99e3839f45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21dbc6348440643a9c0d6c27e613d0caddd4425a5dc1f051149ed15b8af6ad9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c447422d84d879f33b16e988a0fc146be1941bf49c4f12ba06b3b21c8e61f7ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24fefc7bf024346dd770233cf6fead5dd3917cd3a22642c1336d0aa33aca2ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6983d6584aeec58862e0066f2533432b1a8485468e4083d7294db1a9b0a888ce"
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
