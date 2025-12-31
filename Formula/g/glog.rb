class Glog < Formula
  desc "Application-level logging library"
  homepage "https://google.github.io/glog/stable/"
  url "https://github.com/google/glog/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "00e4a87e87b7e7612f519a41e491f16623b12423620006f59f5688bfd8d13b08"
  license "BSD-3-Clause"
  head "https://github.com/google/glog.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db7706b1f7d29240796ce138101d3d18f02d9d2e2be542f38c5ca157e91dd84c"
    sha256 cellar: :any,                 arm64_sequoia: "0815d02daeafc23dbe271d1094bd07ab4c736f09d6f2f4db49246d1f2473955c"
    sha256 cellar: :any,                 arm64_sonoma:  "98570364c65f024c6c288284a250f9a93420b6acb45d9ed0abc5790e17d8bb85"
    sha256 cellar: :any,                 sonoma:        "1b3afc19df4514dd0bbd4368940e25df58802dde175d5b07552b8ff66d3927f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "148610f0d05d41387d7dd402fec0b7cafbe2603a7a5745734ecd6db50f279425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0624b3d83129dd0efe76d79ae8c8f5a406e98b0b6a49b7ad5d6915ed669f4e4c"
  end

  # deprecate! date: "2025-12-10", because: :repo_archived, replacement_formula: "abseil"

  depends_on "cmake" => [:build, :test]
  depends_on "gflags"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DWITH_PKGCONFIG=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glog/logging.h>

      int main(int argc, char* argv[]) {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0)
      find_package(glog CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test glog::glog)
    CMAKE

    ENV["TMPDIR"] = testpath
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test"

    assert_path_exists testpath/"test.INFO"
    assert_match "test.cpp:5] test", File.read("test.INFO")
  end
end
