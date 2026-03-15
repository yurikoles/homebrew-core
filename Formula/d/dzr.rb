class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https://github.com/yne/dzr"
  url "https://github.com/yne/dzr/archive/refs/tags/260315.tar.gz"
  sha256 "3bf9f3121cbbd35a4d3fb83d1869d3047abe32db157705a4d68aaf441c6ea0fe"
  license "Unlicense"
  head "https://github.com/yne/dzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d8ec1e8f5f8fcb935b681abe19505f33722d4924b94e1af4c82fc10e3eacaaa9"
  end

  depends_on "dialog"
  depends_on "mpv"

  uses_from_macos "jq", since: :sequoia

  def install
    bin.install "dzr", "dzr-url", "dzr-dec", "dzr-srt", "dzr-id3"
  end

  test do
    ENV.delete "DZR_CBC"
    assert_equal "3ad58d9232a3745ad9308b0669c83b6f7e8dba4d",
                 Digest::SHA1.hexdigest(shell_output("#{bin}/dzr !").chomp)
  end
end
