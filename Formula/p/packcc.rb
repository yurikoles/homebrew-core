class Packcc < Formula
  desc "Parser generator for C"
  homepage "https://github.com/arithy/packcc"
  url "https://github.com/arithy/packcc/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "26fa5c99ea36c4632fcb231479d01f354d016d2d8d97d74c44c08bc1924ae0a6"
  license "MIT"
  head "https://github.com/arithy/packcc.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "54055b2cfa7a1cfc71b4577a6675f81086f0dbc4c103e304786d1621c3a14bec"
    sha256 arm64_sequoia: "9c902b3c71cbfe12ab67936ab985053ea7c7edadbbb24b1ea5a714aaed627ebc"
    sha256 arm64_sonoma:  "7f116411aa3402af32ce7c676d8648300a1c61808530dcc449965680fc2d9610"
    sha256 sonoma:        "c8540a200bed0a98772951daf21d62eea6ce37d9b8845abeca161e9305a3f3c1"
    sha256 arm64_linux:   "376367fd3650589901aefe3b0217dba2c7f153f71bcd7dbff04b1b52d34a9780"
    sha256 x86_64_linux:  "cc760b6612827f5c33e191d7d5102a1d8f48a80ee1ee8ff38ba2e31abaa6521a"
  end

  depends_on "cmake" => :build

  def install
    inreplace "src/packcc.c", "/usr/share/packcc/import", "#{opt_pkgshare}/import"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/ast-calc.v3.peg", testpath
    system bin/"packcc", "ast-calc.v3.peg"
    system ENV.cc, "ast-calc.v3.c", "-o", "ast-calc"
    output = pipe_output(testpath/"ast-calc", "1+2*3\n")
    assert_equal <<~EOS, output
      binary: "+"
        nullary: "1"
        binary: "*"
          nullary: "2"
          nullary: "3"
    EOS
  end
end
