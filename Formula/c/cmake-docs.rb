class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.1/cmake-4.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.1.tar.gz"
  sha256 "0798f4be7a1a406a419ac32db90c2956936fecbf50db3057d7af47d69a2d7edb"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "126d962faeb7fb24aa9de2a90ecd899668e277011add581fd9e7aedc5d2af133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "126d962faeb7fb24aa9de2a90ecd899668e277011add581fd9e7aedc5d2af133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "126d962faeb7fb24aa9de2a90ecd899668e277011add581fd9e7aedc5d2af133"
    sha256 cellar: :any_skip_relocation, sonoma:        "126d962faeb7fb24aa9de2a90ecd899668e277011add581fd9e7aedc5d2af133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c31cc30e4ebec063fa551be0d322f797bca356b4f6a21c293525d2b07fe02f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c31cc30e4ebec063fa551be0d322f797bca356b4f6a21c293525d2b07fe02f5"
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
