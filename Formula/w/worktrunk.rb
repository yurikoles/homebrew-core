class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "551250eaebb7bd70b952a444f92a229543d2726f6b4340665f3badd9b1a01cdc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f312ce3a48c960d2cde4a4d629cc54ec033943c7a2faef01ae9cdb2095f6dc94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b95d7c9ee2dba3a57cb918f22f51c1dd989fdf38cfdd5b820f701f99dd406a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb12f3b61aee5e1fd50fc16c76f9d77d37c1dc0a3f399cd226af7551e81a6bae"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa7174a05c368a8d73a38a58a1cf47accbc3ae7459a50d14a65502f7cb5e553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31aed588f09113012495cbce6b36ea78a3648831eb607c819e24fe253dbe4bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5977751574523e0593da139803e86833a1f7e88869225387e5caf28954249536"
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
