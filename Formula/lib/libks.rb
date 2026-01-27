class Libks < Formula
  desc "Foundational support for signalwire C products"
  homepage "https://github.com/signalwire/libks"
  url "https://github.com/signalwire/libks/archive/refs/tags/v2.0.10.tar.gz"
  sha256 "cd0d8504870c2e0e1306e55fd27dede976ab9f3a919487bc10b526576d24d568"
  license all_of: [
    "MIT",
    "BSD-3-Clause", # src/ks_hash.c
    "HPND",         # src/ks_pool.c
    :public_domain, # src/ks_utf8.c, src/ks_printf.c
  ]
  head "https://github.com/signalwire/libks.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ba56f2168609a91383abc75e3fac558628d5b729aa0bbdb98ee715b462b1948"
    sha256 cellar: :any,                 arm64_sequoia: "8eae0c7fa3f85ddd3590395a47673945f59cd05bb895cee3f1dc668cc119914c"
    sha256 cellar: :any,                 arm64_sonoma:  "7dde0eb9531c006912cd9760a066ed948abd7c2f74fedee0c8d9b72f289d52a8"
    sha256 cellar: :any,                 sonoma:        "bd3a093a55efcec8aa4210e1e0e27aff50bb1fad3906b3987a20df01925a7ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a61b1635a1bbf9e706a81f1a55e8b56c548c5e9c9715e3147e4ae57159d0ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed3213ffd82b950d4c4ef618dbff54199021392f9e741e0eed49841a4efce896"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = ["-DWITH_PACKAGING=OFF"]
    args << "-DUUID_ABS_LIB_PATH=#{MacOS.sdk_for_formula(self).path}/usr/lib/libSystem.tbd" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Part of https://github.com/signalwire/libks/blob/master/tests/testrealloc.c
    (testpath/"test.c").write <<~C
      #include <libks/ks.h>
      #include <assert.h>

      int main(void) {
        ks_pool_t *pool;
        uint32_t *buf = NULL;
        ks_init();
        ks_pool_open(&pool);
        buf = (uint32_t *)ks_pool_alloc(pool, sizeof(uint32_t) * 1);
        assert(buf != NULL);
        ks_pool_free(&buf);
        ks_pool_close(&pool);
        ks_shutdown();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/libks2", "-L#{lib}", "-lks2"
    system "./test"
  end
end
