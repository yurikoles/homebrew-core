class Phantom < Formula
  desc "CLI tool for seamless parallel development with Git worktrees"
  homepage "https://github.com/phantompane/phantom"
  url "https://registry.npmjs.org/@phantompane/cli/-/cli-6.0.0.tgz"
  sha256 "5ceb6247f4b8ef507086927e3ebc9edbd1b62a3613e79c45d55a77b955ba679a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf8840cb0e590d744495851480d7a6468d6b528767dd1eb882a1fa2d2d863026"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"phantom", "completion", shells: [:fish, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phantom --version")

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"

    (testpath/"README.md").write "homebrew-test"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    system bin/"phantom", "create", "test-worktree"

    assert_match(/\btest-worktree\b/, shell_output("#{bin}/phantom list"))

    worktree_path = testpath/".git/phantom/worktrees/test-worktree"
    assert_equal worktree_path.to_s, shell_output("#{bin}/phantom exec test-worktree pwd").chomp

    system bin/"phantom", "delete", "test-worktree"
    refute_match(/\btest-worktree\b/, shell_output("#{bin}/phantom list"))
  end
end
