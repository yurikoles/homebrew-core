class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/50/adwaita-icon-theme-50.0.tar.xz"
  sha256 "fac6e0401fca714780561a081b8f7e27c3bc1db34ebda4da175081f26b24d460"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb850642a89f3e7e8341fc010e2fc4791933160f275ec6e93848ae3783dce02c"
  end

  depends_on "gtk4" => :build # for gtk4-update-icon-cache
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "librsvg"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # This checks that a -symbolic png file generated from svg exists
    # and that a file created late in the install process exists.
    # Someone who understands GTK4 could probably write better tests that
    # check if GTK4 can find the icons.
    png = "audio-headphones.png"
    assert_path_exists share/"icons/Adwaita/16x16/devices/#{png}"
    assert_path_exists share/"icons/Adwaita/index.theme"
  end
end
