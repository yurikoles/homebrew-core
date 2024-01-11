class Mesa < Formula
  desc "Graphics Library"
  homepage "https://www.mesa3d.org/"
  url "https://mesa.freedesktop.org/archive/mesa-24.0.0.tar.xz"
  sha256 "dc7e8c077bc5884df95478263b34bdebb7e88e600689cb56fb07be2b8c304c36"
  license "MIT"
  head "https://gitlab.freedesktop.org/mesa/mesa.git", branch: "main"
  bottle do
    sha256 arm64_sonoma:   "d0b6404228b99cc7efc679423852356da1ab39d9da3191592141f352a6d21b7a"
    sha256 arm64_ventura:  "f3d8317d0e6b5af50b59d34d1567df207356d1f74dd938918d6c35328a113432"
    sha256 arm64_monterey: "3560ec710171e12216c7a665bfce7ff8cd2bf991c0797b492f9d4289e60e7e39"
    sha256 sonoma:         "79e95821dce33781c671a13c5e20765779a7a3fc626e175e40f52482eae7922c"
    sha256 ventura:        "9929ffa56fe085ea4366aea4f6078895dd933a7a26bc5e144abf787c7f12889f"
    sha256 monterey:       "1dae004a54738dc3647cd6f2898f6b6b50363192bc9d68cbef7cc5c7b97a3cb1"
    sha256 x86_64_linux:   "9456f802c45c8bddf944fa8ddce994ae2d1a464c87eab9ac95ecbb8807746d52"
  end

  depends_on "bison" => :build # can't use from macOS, needs '> 2.3'
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pygments" => :build
  depends_on "python-mako" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "xorgproto" => :build

  depends_on "expat"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxdamage"
  depends_on "libxext"

  uses_from_macos "flex" => :build
  uses_from_macos "llvm"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "elfutils"
    depends_on "glslang"
    depends_on "gzip"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libxfixes"
    depends_on "libxrandr"
    depends_on "libxshmfence"
    depends_on "libxv"
    depends_on "libxxf86vm"
    depends_on "lm-sensors"
    depends_on "wayland"
    depends_on "wayland-protocols"
  end

  fails_with gcc: "5"

  resource "glxgears.c" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/391cafee6d43a28afaf87a269475e0ede7d97469/src/xdemos/glxgears.c"
    sha256 "294d7b9984eb1194a110a5a5500878df8b8d7b7922ec56257e9d8d8ae5e578e6"
  end

  resource "gl_wrap.h" do
    url "https://gitlab.freedesktop.org/mesa/demos/-/raw/ddc35ca0ea2f18c5011c5573b4b624c128ca7616/src/util/gl_wrap.h"
    sha256 "41f5a84f8f5abe8ea2a21caebf5ff31094a46953a83a738a19e21c010c433c88"
  end

  def install
    args = ["-Db_ndebug=true"]
    compile_args = []

    if OS.linux?
      args += %w[
        -Dplatforms=x11,wayland
        -Dglx=auto
        -Ddri3=enabled
        -Dgallium-drivers=auto
        -Dgallium-omx=disabled
        -Degl=enabled
        -Dgbm=enabled
        -Dopengl=true
        -Dgles1=enabled
        -Dgles2=enabled
        -Dvalgrind=disabled
        -Dtools=drm-shim,etnaviv,freedreno,glsl,nir,nouveau,lima
      ]
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    inreplace lib/"pkgconfig/dri.pc" do |s|
      s.change_make_var! "dridriverdir", HOMEBREW_PREFIX/"lib/dri"
    end

    if OS.linux?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  test do
    %w[glxgears.c gl_wrap.h].each { |r| resource(r).stage(testpath) }
    flags = %W[
      -I#{include}
      -L#{lib}
      -L#{Formula["libx11"].lib}
      -L#{Formula["libxext"].lib}
      -lGL
      -lX11
      -lXext
      -lm
    ]
    system ENV.cc, "glxgears.c", "-o", "gears", *flags
  end
end
