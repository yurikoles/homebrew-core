class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://www.supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.7.0/SuperTux-v0.7.0-Source.tar.gz"
  sha256 "32fc5b99b9994ed58e58341d6f21de925764b381256e108591136de53bc31da5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f30e013af1d8f3bb1d2b99c0ac72b98fa0c9a46840814b97a0c8890eb999dc5b"
    sha256 cellar: :any,                 arm64_sequoia: "01ebea1522024f5f5cd9d24c2a1914b68f827634157a137ae562609709d7cd97"
    sha256 cellar: :any,                 arm64_sonoma:  "34dd087568e006e80bd54e7541b4f8168f9bba8e37858af92305e145b5073937"
    sha256 cellar: :any,                 sonoma:        "8b514eefd571f39fdca1ca0ea2b3b061b1a13570bb42475c6771855cbd649101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c0f614acac9dba3b3b455793df275e63775ea58af94c1fbc8c8e51fd2219fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0be5ada884d712e94104eb8c14cf314cfdfc0ac32d81adcda88ecd2104e029f"
  end

  head do
    url "https://github.com/SuperTux/supertux.git", branch: "master"

    depends_on "fmt"
    depends_on "openal-soft"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fmt"
  depends_on "freetype"
  depends_on "glew"
  depends_on "glm"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "openal-soft"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"

  uses_from_macos "curl"

  on_linux do
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      "-DINSTALL_SUBDIR_BIN=bin",
      "-DINSTALL_SUBDIR_SHARE=share/supertux",
      # Without the following option, Cmake intend to use the library of MONO framework.
      "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove unnecessary files
    rm_r(share/"applications")
    rm_r(share/"pixmaps")
    rm_r(prefix/"MacOS") if OS.mac?
  end

  test do
    (testpath/"config").write "(supertux-config)"
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --userdir #{testpath} --version").chomp
  end
end
