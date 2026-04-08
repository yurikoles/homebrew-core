class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "551250eaebb7bd70b952a444f92a229543d2726f6b4340665f3badd9b1a01cdc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2522d7a31beef338921dad8ac6cb116f26640b13f75b8e8a56bdb8fcf576640"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c76fec5a8e7c12494e7b1571f54c233fa26a3321d30233da9a820ccc34116d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ea08b7df1f682323ebbbe590a0ea17f738f14424639f9a9afa14ef87efe2ba4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a1080f82259a8d6d5fcb69d4a651cbc8d52b7ed95bbfe08779b819f60a1297f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d722b3a9f812a76614f0f797e529ef16e290a9810014c93f9e54b84e1b6df308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af2becf9032c2fed13367918c668f975a43ef134ff88b3a8836c9c5d65d0ba2a"
  end

  depends_on "rust" => :build

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"wt", "config", "shell", "completions")
  end

  test do
    system "git", "init", "test-repo"

    cd "test-repo" do
      system "git", "config", "user.email", "test@example.com"
      system "git", "config", "user.name", "Test User"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"

      # Test that wt can list worktrees (output includes worktree count)
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end
