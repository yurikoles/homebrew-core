class Nip4 < Formula
  desc "Image processing spreadsheet"
  homepage "https://github.com/jcupitt/nip4"
  url "https://github.com/jcupitt/nip4/releases/download/v9.1.0/nip4-9.1.0.tar.xz"
  sha256 "16fdb9be15369be2f35e9d9041073103b45aab33afd774dd2218bb11fa5d45c6"
  license "GPL-2.0-or-later"
  head "https://github.com/jcupitt/nip4.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d010e5b461ca280bb6ccd0b28e2968e0ec43f4d353bc2d116af6501ff7f3ec7d"
    sha256 cellar: :any, arm64_sequoia: "c1b9f0b6c4b5b512f503204895874841d71acea49d928eadedb091bba140c255"
    sha256 cellar: :any, arm64_sonoma:  "10945343d0b1ac87ecd3c0a844c30894584123c169263bc7dab6c927c3b079ed"
    sha256 cellar: :any, sonoma:        "5e4c06ac9a604e62e610439e92f2d5544c9270c678bbe0dde826b49365770768"
    sha256               arm64_linux:   "ffbdc7e57f29ae1deb0cc43456c881d43852ae73d71b4ee6b227a4fa0d146c4b"
    sha256               x86_64_linux:  "9f64cfcf57a86ee35f3651cfd09d28d67331cbd4a53976a3c26d539dd3acb5ec"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gsl"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "vips"

  def install
    # Avoid running `meson` post-install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/nip4 --version")

    # nip4 is a GUI application
    spawn bin/"nip4" do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
