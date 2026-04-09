class Nbytes < Formula
  desc "Library of byte handling functions extracted from Node.js core"
  homepage "https://github.com/nodejs/nbytes"
  url "https://github.com/nodejs/nbytes/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "67f4b8363f12abb64c07a0cecf2bf2dce7ab47b5f8b9fd2efdb852ea254c2d40"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e400f4460fca0bd6bf25d2239342bffdfa73ba62a525fbaaaaf2f79731e185e"
    sha256 cellar: :any,                 arm64_sequoia: "fe1bc7b5397bd0322aa723cae5808c7cb7acc3d52147788dc872d621dc0470f5"
    sha256 cellar: :any,                 arm64_sonoma:  "a756061ca6d2657a8c00de66ea4c66efa53562d2e2224a141c6b4c81904150a3"
    sha256 cellar: :any,                 sonoma:        "1ff8ca849ec2a74b332e0aff1b97d510a393c1bf79c19d60ccf87b2d5feda5a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f911482f5523014176fc48f06dfb3e8cb0e1bb5e9b89f336170200d1b37c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a78948ebf2c939802226061ccdffc538a6b9918bdbd22e88659134cc51f12a3"
  end

  depends_on "cmake" => :build

  def install
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
