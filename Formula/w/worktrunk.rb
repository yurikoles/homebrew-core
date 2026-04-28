class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "aca758060f417ed5c5283894b62b7918bdb13d31c7feba11bd7c5cd656cb9958"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d575574c3a9e2f24cdfc29c3f023f6f5d075a42c82387383859bbef09b7369cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f59046404b237d47a58d57d19e9343d668b815753f27d601b1bf389f188e5e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b30d17d69b823ec68c3abe91bc76ff28b33bc2cc6a45faf5f784cf411f82bb4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3b9b1c056b2d6c55f51a48330902a500486dd01dbae4d3bc4af522e313c6370"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ceb70c97796fae0fe9fc5067078d2ef810045a3735218f1fbaff0b90dfedd2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f69ac4ac7332ee9f8a3cce62262e2953603cdd86491f27d68acf4a1ed1b5915"
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
