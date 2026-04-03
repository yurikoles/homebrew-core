class Nbytes < Formula
  desc "Library of byte handling functions extracted from Node.js core"
  homepage "https://github.com/nodejs/nbytes"
  url "https://github.com/nodejs/nbytes/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "556b4bbe3ed747cea1d4466133f7abb82595f38c8f808be1d248b0bf8682e509"
  license "MIT"

  depends_on "cmake" => :build

  def install
    # Remove buildtime tests
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "FetchContent_MakeAvailable(googletest)", ""
      s.gsub! "enable_testing()", ""
      s.gsub! "add_subdirectory(tests)", ""
    end

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test-main.cpp").write <<~CPP
      #include <nbytes.h>
      #include <iostream>

      int main() {
        constexpr char input[] = "SGVsbG8sIFdvcmxkIQ=="; // "Hello, World!"
        char output[64] = {};
        size_t n = nbytes::Base64Decode(output, sizeof(output), input, sizeof(input) - 1);
        std::cout << output << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++20", "test-main.cpp", "-I#{include}", "-L#{lib}", "-lnbytes", "-o", "test-main"

    assert_equal "Hello, World!\n", shell_output("./test-main")
  end
end
