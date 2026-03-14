class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://github.com/hunspell/hunspell/releases/download/v1.7.2/hunspell-1.7.2.tar.gz"
  sha256 "11ddfa39afe28c28539fe65fc4f1592d410c1e9b6dd7d8a91ca25d85e9ec65b8"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d2821926f2ded88b146f72f281ad7144485140429a432a21bf187eb90558d57f"
    sha256 cellar: :any,                 arm64_sequoia:  "98c354c4b2d30399b17d20622cddfbbbc27a2a33fbde6c53a9445375ab4d6c61"
    sha256 cellar: :any,                 arm64_sonoma:   "7c5fef61ba38c643c6e29cdb3e835875011411edf1f421a7f0329e1723c6e397"
    sha256 cellar: :any,                 arm64_ventura:  "97e8e1bbf7cbad6fa97efd96711e0ff25d46cd98bd19c75dab4d1160c00b591d"
    sha256 cellar: :any,                 arm64_monterey: "0077d77fd9cc1a47eb3b0e78818c91735899879fab8373acbc41bccf74cbd2cc"
    sha256 cellar: :any,                 arm64_big_sur:  "1f0389abc127deb93d7230497181af1d2cbc18a354127b98f7aa1a7a47e56279"
    sha256 cellar: :any,                 sonoma:         "824cc2f1c917cc1a43872bbf9b36fba99072458de10b41631097dcf62e0d82f2"
    sha256 cellar: :any,                 ventura:        "c0770e77b09220da99d9dc5f169a5a815b08b77350a7396ef1017d131fc2a800"
    sha256 cellar: :any,                 monterey:       "a4f7164470263a3d9b5511136680475f91c5f4498b6d58097f18a8ee496cc3da"
    sha256 cellar: :any,                 big_sur:        "9d58f7687ab71647524ada2ab980193d7083357072b15510d756e6f90a769830"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cfbe072b957d6e8dcc23af726175c10452cd2069e0ff9e0e54c3ce064fe626e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ba93523c0b255617dd5c9771da092b73a9e9f40f0e7f5c727b7b181f6c8248"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build

  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with "freeling", because: "both install 'analyze' binary"

  skip_clean "share/hunspell"

  # Backport support for searching hunspell dictionaries in pkgshare
  patch do
    url "https://github.com/hunspell/hunspell/commit/874abbbe65e228df525023afe176b42df34a7a4f.patch?full_index=1"
    sha256 "b1b59cc11e720a047302b72ce1870712f29ca22f3023726c576ffd6f713d2841"
  end

  def install
    # Regenerate configure to use patch
    odie "Remove autoreconf and build dependencies!" if version > "1.7.2"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules",
                          "--with-ui",
                          "--with-readline",
                          *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"

    # Find dictionaries installed by other formulae
    share.install_symlink HOMEBREW_PREFIX/"share/hunspell"
  end

  def caveats
    <<~EOS
      Dictionary files (*.aff and *.dic) should be placed in
      ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
      provides no dictionaries for Hunspell, but you can download
      compatible dictionaries from other sources, such as
      https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ .
    EOS
  end

  test do
    system bin/"hunspell", "--help"
  end
end
