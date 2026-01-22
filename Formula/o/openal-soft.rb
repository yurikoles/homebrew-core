class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "https://openal-soft.org/"
  license "LGPL-2.0-or-later"
  head "https://github.com/kcat/openal-soft.git", branch: "master"

  stable do
    url "https://openal-soft.org/openal-releases/openal-soft-1.25.1.tar.bz2"
    sha256 "4c2aff6f81975f46ecc5148d092c4948c71dbfb76e4b9ba4bf1fce287f47d4b5"

    # Backport support for GCC <= 12
    patch do
      url "https://github.com/kcat/openal-soft/commit/abd510d0aa7a27afc48af25c24ee6d6b544053cb.patch?full_index=1"
      sha256 "4b172d4e0765978562e16ab9cc8226f45b33521f6e4935ff3cc8ef570e57c268"
    end
    patch do
      url "https://github.com/kcat/openal-soft/commit/b8c3593740630cdb3577fcb381e092898759064a.patch?full_index=1"
      sha256 "77d73ff7cf500a46940e2392e2348ca3357f491628abe06a0f36ad4391630ccb"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?openal-soft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11fe9b015e4afb353bf87231aff595f40c4aa260c386145564ed7eacbfd755d5"
    sha256 cellar: :any,                 arm64_sequoia: "dd26fef51c1884b65ea8fcbed3185d29e3ed93df6f61f1551b8c07c956d293d2"
    sha256 cellar: :any,                 arm64_sonoma:  "c669777ed1c01c23d12f3f9d63baa8a17c6bd64f9041d0f3a9f4423e9e1777b7"
    sha256 cellar: :any,                 arm64_ventura: "adda1372155c4d3108305387fdcbb01fbff2d579fdb77e41f941e6ed74bf27f1"
    sha256 cellar: :any,                 sonoma:        "8a47616d6f215a0199e0d986833cf2e3e2bbb1481a5c29db50cbd543a7cbbe2e"
    sha256 cellar: :any,                 ventura:       "608b94ed45a93779809ae82bda26347504a78a0dfc16383472cbff6d22a9251a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f3b41687a7a0f2c45a9d5969279798c77abd097a180749075c7db06739fad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e51027b581006b7ebcbe897a77d471506cf32d85f887546754ee3cb1edb17cc"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenAL.framework"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_linux do
    depends_on "binutils" => :build # Ubuntu 22.04 ld has relocation errors
  end

  fails_with :clang do
    build 1699
    cause "error: no member named 'join' in namespace 'std::ranges::views'"
  end

  def install
    # Please don't re-enable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = %W[
      -DALSOFT_BACKEND_PORTAUDIO=OFF
      -DALSOFT_BACKEND_PULSEAUDIO=OFF
      -DALSOFT_EXAMPLES=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "AL/al.h"
      #include "AL/alc.h"
      int main() {
        ALCdevice *device;
        device = alcOpenDevice(0);
        alcCloseDevice(device);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopenal"
    system "./test"
  end
end
