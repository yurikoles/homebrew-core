class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "44d99d3afc2f7ec56a472394390c8339dc21711e500f0d21215838cbe440cd17"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "677b9543389ace25a731684860474e6190967a2bc30c77543bca8d92e66a574e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "677b9543389ace25a731684860474e6190967a2bc30c77543bca8d92e66a574e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "677b9543389ace25a731684860474e6190967a2bc30c77543bca8d92e66a574e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc27831a6f1e552585cd2450a504c4f8e78dd3924c9e768a7289c2c9aff4c17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c263c89a109ae466aa6d43762f178ec47bce77206dc717e97c38e12eca31a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975a5bfb24ba5368778dc3478a6e13122d6b094d13f5aa7a5174055f9ddb4d31"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end
