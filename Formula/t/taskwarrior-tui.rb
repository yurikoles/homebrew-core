class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.7.tar.gz"
  sha256 "d0bf2b9c5563165565db7941c7806f58c1c54f8bcb5f8d1430b0d35f1da7678d"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10cb96f44c2c32f06bbc0601abbfc05675a3d5d91926ad6cd23dd74cb4f1243b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95ae53019f74057399acdff9f17df2a2342d56f534ecb6c63401370194b48662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "691dfa7011ac00abc15e591b368ccfef2f6009957f79ba71e9158d5ba2532bbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0910367aa279a1394798b4f9de8e42c1e7c77450553891588c9a929ac522870f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59acf30013e9a7e0f5633d6b124af9aa4df521b85eb1cf8bb84e233ac1a2987b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1abf32ba45caf72c21cdd3f1ca5761c2ed8690718f928faa6c8006c56b70c46b"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash" => "taskwarrior-tui"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
