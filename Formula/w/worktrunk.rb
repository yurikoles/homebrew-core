class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "ac14ad3469ecb3e2b2a7f06c92eb346a043a644eb917a3d8338e2d39522cfc2b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "311d03e570c4be9e5ede5419918a143db541ac785e08ce810ddd9e8e14097c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f5fbbdf82ab6b5390e18f191b9da4dd061b96550af26624b272a700e76a4e1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59a9f8704c9ad9630734d857d74389335fce5600d6881246697985ca7a3b0db7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb01c4ce6b1da320fa32eda011d41ee71e56febda1ac6fbaf6da982b02ca4cf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46865b1b284e239840e775c3268d845be3b83e442cc645470fe36c2c18e11187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6093b4f668b44c770633713058769c9a55fae9e161778f01bc74e2dce9e1368b"
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
