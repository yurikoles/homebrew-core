class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.11.tar.gz"
  sha256 "88846c0ebb8d3e1af9310330a3b35a9a58473cc8807a5f674a3005f990eb5b29"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d649d8c61a193ae10e1b68336749fbcb175ba42d799c47b353781cf9102e304d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b5b71ec50a5d34404bc7bf7dcae84e7e209d9a14fd912b639ee2203815b955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db38f768300c00ab5dcdca6ed5efaccedea3828933d6a4da6e20d26bfcc97328"
    sha256 cellar: :any_skip_relocation, sonoma:        "147c7ab6eb4ad98c90c4108d10cf8e8c81fde440c67410232bd6bf596fced61a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8682011cd00327c669230119547e3fa3a97235d718be9472c4e9abaa5c54e55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c33283c96e8f2c7402fe9939b0e3600c3107b01629c5728b6e1d454b99d0c896"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "packaging/man/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
    man1.install "taskwarrior-tui.1"

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
