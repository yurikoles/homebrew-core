class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.2/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.2.tar.gz"
  sha256 "b0231eb39b3c3cabdc568c619df78208a7bd95ea10c9b2236d61218bac1b367d"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f47fbd678cfffa1b0e7da144ef18c8465b7d5f11ceb4c238d60a4e7973edd2a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47fbd678cfffa1b0e7da144ef18c8465b7d5f11ceb4c238d60a4e7973edd2a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f47fbd678cfffa1b0e7da144ef18c8465b7d5f11ceb4c238d60a4e7973edd2a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f47fbd678cfffa1b0e7da144ef18c8465b7d5f11ceb4c238d60a4e7973edd2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f39a1c1c3776a4edcf0ab699c111aecf687ede040d12ca0a2328af05475fb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f39a1c1c3776a4edcf0ab699c111aecf687ede040d12ca0a2328af05475fb7a"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
