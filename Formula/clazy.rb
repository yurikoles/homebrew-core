class Clazy < Formula
  desc "Qt-oriented static code analyzer based on the Clang framework"
  homepage "https://apps.kde.org/clazy"
  url "https://download.kde.org/stable/clazy/1.9/src/clazy-1.9.tar.xz"
  sha256 "4c6c2e473e6aa011cc5fab120ebcffec3fc11a9cc677e21ad8c3ea676eb076f8"
  license "LGPL-2.0-or-later"

  depends_on "cmake" => :build
  depends_on "qt" => [:build, :test]
  depends_on "llvm"

  def install
    args = std_cmake_args
    args << "-DBUILD_HTML_DOCS=ON"
    args << "-DBUILD_MAN_DOCS=ON"
    args << "-DBUILD_QTHELP_DOCS=ON"
    args << "-DBUILD_TESTING=OFF"

    system "cmake", ".", *args
    system "make", "install"
    
    pkgshare.install "tests"
  end

  test do
    cp_r pkgshare/"tests", testpath
    cd testpath/"tests"
    system "./run_tests.py"
  end
end
