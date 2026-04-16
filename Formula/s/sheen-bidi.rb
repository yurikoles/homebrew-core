class SheenBidi < Formula
  desc "Sophisticated implementation of Unicode Bidirectional Algorithm"
  homepage "https://github.com/Tehreer/SheenBidi"
  url "https://github.com/Tehreer/SheenBidi/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "86c56014034739ba39a24c23eb00323b0bf6f737354f665786015fca842af786"
  license "Apache-2.0"
  head "https://github.com/Tehreer/SheenBidi.git", branch: "master"

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
