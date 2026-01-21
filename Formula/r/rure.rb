class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://static.crates.io/crates/rure/rure-0.2.4.crate"
  sha256 "e76c0d9cbe885d29bf9a65974d9230e4d67c066ccfa07ab791926e73a181bcfc"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b547a58eeaee0300651c51732926185ac7980a3db0f96f8bb9293c9b4814ab9"
    sha256 cellar: :any,                 arm64_sequoia: "c18fe191416b5476dd21fcb82e692f1b9500ee81b1137faa77f5d17127960ea2"
    sha256 cellar: :any,                 arm64_sonoma:  "7c62227e56370461779551cc709eef19a0d32722e934eb790838e0d08d9e23db"
    sha256 cellar: :any,                 sonoma:        "7e13a0d626d1dd0f67766bc44d13a0def8adcdf60ef4653f57a1757df5d7bea9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9886fefaea72497fd7ab3b94c8ed90d804b59456541df6f2270bda8025c21c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062c9130b42d3fcc9db37c902413dd13effefcfb828c540b3001d050d8bf47d9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release"
    include.install "include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end
