class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "https://www.gethomebank.org/en/index.php"
  url "https://www.gethomebank.org/public/sources/homebank-5.9.7.tar.gz"
  sha256 "2b8fdf512429a30ed7a457cf5af476756c0cfddc9fce7600dab95c7f03be26e4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gethomebank.org/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9f89d7fb7213ee3b39a0dd6e271d5c67aba04d04296f384814b10a146d25cff6"
    sha256 arm64_sequoia: "6fad90e911e7b4f35abebd7618081ce7379d0470c6be1fdde9f7a9c9e82712ed"
    sha256 arm64_sonoma:  "215d825b353afddbb69fcb61a13e04d89ea2d258bdfc15090de362f4188f6dd7"
    sha256 sonoma:        "1cfb79ab1182f869c33e09d85b85868f1038d3e5e5283e21e2c38e1a5da15b9d"
    sha256 arm64_linux:   "6c48c62f28a07472024fdf43035f404dbaeb5871241d85a84ddbe1b772fe730c"
    sha256 x86_64_linux:  "4fafbfca53d6c6c09c736a1260e8ad9c4dbc5267000f31eccf8d7dffd922e462"
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./configure", "--with-ofx", *std_configure_args
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end
