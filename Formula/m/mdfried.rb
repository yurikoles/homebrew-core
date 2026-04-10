class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "2bbf92de29663380874747cd05b9a674df4984c89fe43584a01eb6072105c087"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a898e47a9157e5bff6a5e58578cf4cffbad7223da0fbc3c591a2236751d539b5"
    sha256 cellar: :any,                 arm64_sequoia: "c42a8932eb3f1df396d5c10558881f89928845ed0d0190a2b061b37142973d63"
    sha256 cellar: :any,                 arm64_sonoma:  "39f84091751928c1107d97d8468c1cfac4afa778d3f026c4ecda29e3db982037"
    sha256 cellar: :any,                 sonoma:        "b5965721c8ede08a87630a040884e0e24c1cb144f83579356ae9683dd29008a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f58daa986620a633a7268c4d9ebf5c6e247aac959bd8373d398e30ca3f86ef0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b290c8a7608dc84a8507d8dcc09f207b0262ebfc6918c6edf320e3813558cab0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
