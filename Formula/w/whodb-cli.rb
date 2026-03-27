class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  url "https://github.com/clidey/whodb/archive/refs/tags/0.103.0.tar.gz"
  sha256 "8b6ff9afe4b544c15d3d0022be550c2d4945c46a85d82505b8c37820152b392e"
  license "Apache-2.0"
  head "https://github.com/clidey/whodb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3547f3760b95270a2bcc18879edf345a4558275a522c67157c5a5f2a0df881a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1187df23cbbe24a64e1102ac53de495940adcca318ca675d80fc33b8509015ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e683c44ba70a3b9bc150217921ec2f4d66ee4dc5cb812dc893bbb2d3f4f12d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d8daa4e306e209d52bff62de471db4f74a7646cfaade389349545340b32c40b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2dd191fbb283d865b8a48d49c86e707c16941b6f9ca0a2daf9ec320e18fe75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d6c459664dfcbdd0d8a8f61d1eac3c9724a09c049329d293fad6f7948dfab9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    baml_version = File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?([\d.]+)}, 1]
    ldflags = %W[
      -s -w
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"whodb-cli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb-cli version")

    output = shell_output("#{bin}/whodb-cli connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end
