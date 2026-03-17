class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.17/libde265-1.0.17.tar.gz"
  sha256 "e919bbe34370fbcfa36c48ecc6efd5c861f7df43b9a58210e68350d43bab71a5"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7fc887ff6de361861449c51bd6cfb8a31ab93a91f1d4d76e41332f9e44627afe"
    sha256 cellar: :any,                 arm64_sequoia: "3ae5875dd16e86734c59ff156ef6f03f0cc11f972193e678241ec10ac19dbf48"
    sha256 cellar: :any,                 arm64_sonoma:  "08a3fd4a3e01254f12590f292157a8b92a898d9b4d31659f3e25d34a164f9cd6"
    sha256 cellar: :any,                 arm64_ventura: "2837e8b323ed255ca2efb59a266cd5da0740524758df2d51e5a9834da79720f8"
    sha256 cellar: :any,                 sonoma:        "dcee9a83c604fc27ccb54af849fe45124e12dbf66b63c53d5775aa0c1a49e34c"
    sha256 cellar: :any,                 ventura:       "55f13980c54642c830932f317c1e458882daca74f80118cff8e4bb204ac1b0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "650fa2c9ab2bd73545addb81842bb9442d929b25af4eef7fedfb34a4f93cfe87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bca710186d841ef99740adb1bdd747ae4b0bebb4ffcfa4bc4024199b26c0a5d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"bin")}",
                    "-DENABLE_DECODER=OFF",
                    "-DENABLE_TOOLS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install the test-related executables in libexec.
    (libexec/"bin").install bin/"block-rate-estim",
                            bin/"tests"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <libde265/de265.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        de265_decoder_context *ctx;
        const char *version = de265_get_version();

        if (strcmp(version, LIBDE265_VERSION) != 0) {
          return 1;
        }

        if (de265_init() != DE265_OK) {
          return 2;
        }

        ctx = de265_new_decoder();
        if (ctx == NULL) {
          de265_free();
          return 3;
        }

        printf("%s\n", version);

        de265_free_decoder(ctx);
        de265_free();

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lde265", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip

    assert_match "list ... passed", shell_output("#{libexec}/bin/tests")
  end
end
