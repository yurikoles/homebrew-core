class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.2.0.tar.gz"
  sha256 "d313661eecb75ef754f2839f770ffa64bec6af1fa931eab22fe1d1e996c4a64f"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c36e9e191cbd3fa3da3fae6381873c2ce1915d2def74b87dc71eec9dfa0d67d5"
    sha256 cellar: :any,                 arm64_sequoia: "5c427eb3894e74edb1f8bf57726be8dca9a450d67b5bce185bf03baeccc10808"
    sha256 cellar: :any,                 arm64_sonoma:  "91773c4b688ea7515534cda9fc79d2c2a78ac13515377768d7676ba8f2048213"
    sha256 cellar: :any,                 sonoma:        "d9a1ebfe59b95a681f7891ec6f627f3863ad48273608c8512a5966525c8988d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d8ad047f24d9bae639f51cc7ca767fdae91522849e5d277bed85d63d7836c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d137c36e4d4171004b276dc25bafaa944cfcc0117b093b6a42bcbdd57242ba62"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DMZ_FETCH_LIBS=OFF
      -DMZ_LIB_SUFFIX=-ng
      -DMZ_LIBCOMP=OFF
      -DMZ_PPMD=OFF
      -DMZ_ZLIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip-ng.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdint.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz.h"
      #include "zip.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/minizip-ng", "-L#{lib}", "-lminizip-ng", "-o", "test"
    system "./test"
  end
end
