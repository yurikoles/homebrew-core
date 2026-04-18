class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "6eb47dfcea41bbdd1d234e933aff81a84c74a3ddf6be371ce6a6c801e074941a"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ba4c964084b86c528d592db469ecd7336384ee3e70d710ff92d6307e1f79449"
    sha256 cellar: :any,                 arm64_sequoia: "32e722b3558aea51892cbe6bcfc67ed3b702143939dc0a411171f0c096b4729f"
    sha256 cellar: :any,                 arm64_sonoma:  "e38bb62047ba1ca19b4ca76ccd92db08e8ccc746727aa3a7c8eeb7450f7edd6e"
    sha256 cellar: :any,                 sonoma:        "3a390b2b27cd25022dc505da185ec9f2f8ad4d9dad98afc3349c5784b179fcf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6bce83aaa535f24c2d7341bb6688526a244c4220e9fc0ac0a8fe864c4b5a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e36a07e511e8a9b635a46e9c7aeeacc781d03ac8684523deb4f5ac5cee141d"
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
