class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB"
  homepage "https://www.radare.org/"
  url "https://github.com/radareorg/sdb/archive/refs/tags/2.3.6.tar.gz"
  sha256 "e6ddb7b5faeeeb9f2d06d984a62df1e21acaaad71febd8a1534bf88966fb9b8a"
  license "MIT"
  head "https://github.com/radareorg/sdb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "281e3ceb5a1890ea3bac6107506cb275547d803523a4643d8de41a2cc5a9faab"
    sha256 cellar: :any,                 arm64_sequoia: "242714c5f345106d15759df70cf2f7942d78535e1748092b7c7477582304af95"
    sha256 cellar: :any,                 arm64_sonoma:  "f7fc2055ee92a0ecc62b160630c590e4a88f7a21ce8ca259bfa21a84a215606b"
    sha256 cellar: :any,                 sonoma:        "bd12f2acb355b98355aae695dc50c312f88115267582f6a12399834bf55a0261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99990f59678145671ed55cb5c452b1ea9bcf16993decfd4ad459ae9650b87de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "775ed9f3e72d9785b6cfce1487673722ea429d6da5174e5c5d625eea8cbeffbf"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  conflicts_with "snobol4", because: "both install `sdb` binaries"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
