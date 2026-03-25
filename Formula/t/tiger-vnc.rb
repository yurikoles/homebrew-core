class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "https://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "d00fb52d9863e6bcbef9d6fb8a92170f6e1400114b13dd0efccc0ed0246f6d70"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "11e3ff190f0c4c0ef6dc463548f4f008017a945915683ae3f47db655596fe6aa"
    sha256 cellar: :any, arm64_sequoia: "d76e50a41017f22462257503cb212f4fd3ffd051054af4de10bb856f19f150c2"
    sha256 cellar: :any, arm64_sonoma:  "e821c79d04c568b188ce0cb1f2ec9a960c900f70d5124d6ace0bdbfdef8005db"
    sha256 cellar: :any, sonoma:        "1bc16cfe957b118c7ab360b557830df9095ce073a2c26d949cf03cac32f35c60"
    sha256               arm64_linux:   "321ac5c0240b6f714bd35fa76fdb9660576f4eb3de6430a994cd12bca77baecb"
    sha256               x86_64_linux:  "5bfe19fa4c9024d64cc4e7b40c5e762df20b1acc9cc7c04c4bab469c684b12fe"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "fltk@1.3" # fltk 1.4 issue: https://github.com/TigerVNC/tigervnc/issues/1949
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jpeg-turbo"
  depends_on "nettle"
  depends_on "pixman"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxft"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/vncviewer -h 2>&1", 1)
    assert_match(/TigerVNC v#{version}/, output)
  end
end
