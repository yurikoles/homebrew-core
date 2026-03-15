class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.42.0.tgz"
  sha256 "69631938e3de7adaa48aa52ae0f6bc197b73abee4131ea7067b6d21f5d5b21a0"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7846ccfa323fce4557b6b90a4bc194dcf1c401b674ad89ebde35ab8b0aea8167"
    sha256                               arm64_sequoia: "7846ccfa323fce4557b6b90a4bc194dcf1c401b674ad89ebde35ab8b0aea8167"
    sha256                               arm64_sonoma:  "7846ccfa323fce4557b6b90a4bc194dcf1c401b674ad89ebde35ab8b0aea8167"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ee4b19d673fbffade26bc7ab406d94260f9c02fd2b11cdb4e55dcb377912de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54b00be51d08a70be0c4426dd675c018f3e09bb9ff4dc1b6e3620266a3300fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab81b44c568bb70d42cad92497b84fe6961e1879c24049a8799c2cbed1257bf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
