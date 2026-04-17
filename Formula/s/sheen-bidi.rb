class SheenBidi < Formula
  desc "Sophisticated implementation of Unicode Bidirectional Algorithm"
  homepage "https://github.com/Tehreer/SheenBidi"
  url "https://github.com/Tehreer/SheenBidi/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "86c56014034739ba39a24c23eb00323b0bf6f737354f665786015fca842af786"
  license "Apache-2.0"
  head "https://github.com/Tehreer/SheenBidi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da90384ffa651f7306b191c8675d335e8d487bd1bc792e78e1f7f8fdec25a2f5"
    sha256 cellar: :any,                 arm64_sequoia: "dc4a4d77ebe229806b7e24cd588e6d00f79a3a9b8e0ae3633a61139c09a93149"
    sha256 cellar: :any,                 arm64_sonoma:  "21d7babed02a83a93e7b0da726688902fa1c76e949b1453e66443041bbf3b999"
    sha256 cellar: :any,                 sonoma:        "859191bbfb6d0580b49f4b4a920ac594e93677e50570556daa730929ff13c8c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11ee3016f512270391c63197b69ff51120cb9675ce7030fd5b5bced267bbe840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "794317a822672e57f16c1c717522d0bcd6c0338b150468c5ff55f6e374482a05"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <stdio.h>
      #include <string.h>

      #include <SheenBidi/SheenBidi.h>

      int main(int argc, const char * argv[]) {
        const char *bidiText = "یہ ایک )car( ہے۔";
        SBCodepointSequence codepointSequence = { SBStringEncodingUTF8, (void *)bidiText, strlen(bidiText) };

        return 0;
      }
    C

    pkgconf_flags = shell_output("pkg-config --cflags --libs sheenbidi").chomp.split
    system ENV.cc, "-o", "test", "test.c", *pkgconf_flags
    system "./test"
  end
end
