class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.43.0.tgz"
  sha256 "3eb34f39cfa259985a26f58c65e35316bfcf3c31c2dafe5104173b13b4ae8cb7"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d1c2d0dd49f97baa8e6ebaee01f5b0c02af97503a089ed853d5f91acacd88366"
    sha256                               arm64_sequoia: "d1c2d0dd49f97baa8e6ebaee01f5b0c02af97503a089ed853d5f91acacd88366"
    sha256                               arm64_sonoma:  "d1c2d0dd49f97baa8e6ebaee01f5b0c02af97503a089ed853d5f91acacd88366"
    sha256 cellar: :any_skip_relocation, sonoma:        "a58c2447b592d35e26274d44f50faa27ff19f07fcfeec5a21141664c31e3bae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57551a0348c81456d6a314f57f7c73aa077a423f6a7c7f805bf5eb398ae3537e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c84e0c3f28476736c2b2ff8d0d2151e477b8713385d4e4ce8847ee562346907"
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
