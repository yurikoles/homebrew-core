class Lief < Formula
  desc "Library to Instrument Executable Formats"
  homepage "https://lief.re/"
  url "https://github.com/lief-project/LIEF/archive/refs/tags/0.17.6.tar.gz"
  sha256 "5fbbd19c85912d417eabbaef2b98e70144496356964685b82e0792d708b9be87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09b70e8996ffcb54a272d740a89d97ed804b2439b9a8c4a55c8d514613edf0cd"
    sha256 cellar: :any,                 arm64_sequoia: "a1f01fc921928ca14f60e761075fe0296b18034ba40290553b10b25aedc8d1ba"
    sha256 cellar: :any,                 arm64_sonoma:  "3b509ec8bba9a164b64595f8f07dff0e1e6e3803c3aa8794c9b8b64dd465c4b5"
    sha256 cellar: :any,                 sonoma:        "c79dfac37f44f61e89cc2a94c69dfbf64925041c5cd97f5c04177a0646337a8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66bcc570aac9b6d55cd20e301ca946ef96ced4330882c1589defe77a76312f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b056ac9b673273c48e531cec4469408ca8c152e92d07864cf2f01093e916c5b9"
  end

  depends_on "cmake" => :build
  depends_on "frozen" => :build
  depends_on "nlohmann-json" => :build
  depends_on "utf8cpp" => :build
  depends_on "fmt"
  depends_on "mbedtls@3" # https://github.com/lief-project/LIEF/commit/71e69423090e1bfaee7d2512a843605a373b1026
  depends_on "spdlog"
  depends_on "tl-expected" => :no_linkage

  def install
    rm_r(Dir["third-party/*"] - Dir["third-party/tcb-span*"])

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DLIEF_EXAMPLES=OFF
      -DLIEF_EXTERNAL_SPDLOG=ON
      -DLIEF_OPT_EXTERNAL_EXPECTED=ON
      -DLIEF_OPT_FROZEN_EXTERNAL=ON
      -DLIEF_OPT_MBEDTLS_EXTERNAL=ON
      -DLIEF_OPT_NLOHMANN_JSON_EXTERNAL=ON
      -DLIEF_OPT_UTFCPP_EXTERNAL=ON
      -DLIEF_USE_CCACHE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <LIEF/LIEF.hpp>

      int main(void) {
        std::unique_ptr<LIEF::ELF::Binary> elf = LIEF::ELF::Parser::parse("hello");
        LIEF::ELF::DynamicEntryRunPath runpath("/usr/local/lib");
        elf->add(runpath);
        elf->write("hello-rpath");
        return 0;
      }
    CPP

    cp test_fixtures("elf/hello"), testpath
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-lLIEF"
    system "./test"
    assert_match %r{RUNPATH\s+/usr/local/lib$}, shell_output("objdump -p hello-rpath")
  end
end
