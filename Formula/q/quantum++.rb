class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://github.com/softwareQinc/qpp"
  url "https://github.com/softwareQinc/qpp/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "795c68320115c2110c05642f5cdfa521e5f7a8868c6b446096560b1594eeed6d"
  license "MIT"
  head "https://github.com/softwareQinc/qpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c1c17a10188eda3c602b1822d3e98f6289a6b60de6abc5ac309e1e75fc44435"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "pybind11"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.20)
      project(qpp_test LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      set(CMAKE_CXX_STANDARD 17)

      find_package(qpp REQUIRED)
      add_executable(qpp_test qpp_test.cpp)
      target_link_libraries(qpp_test PRIVATE qpp::qpp)
    CMAKE
    (testpath/"qpp_test.cpp").write <<~CPP
      #include <iostream>
      #include <qpp/qpp.hpp>

      int main() {
          using namespace qpp;
          std::cout << disp(transpose(0_ket)) << std::endl;
      }
    CPP
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal "1  0", shell_output("./build/qpp_test").chomp
  end
end
