class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.256.tar.gz"
  sha256 "9334895dc805bf9089709587d66212a96d7612bc2d6ad0c670d95fcc904496d7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e86d1da3eccc33690387ed8ef2ed7d580781e5736a22f6357c09ad654ff5f567"
    sha256 cellar: :any,                 arm64_sequoia: "23567e742c3c558b957df8572ea3581dfc07f7db5f25d4596bcc4ee279745f55"
    sha256 cellar: :any,                 arm64_sonoma:  "37974467e4a8bdb30037bd660ef1c0fa4c435347608580511ab735b56cc1b6b5"
    sha256 cellar: :any,                 sonoma:        "a86d2914cce1ec2dd0455d043d9dc4772529db30bc97d8fd84965dd058b2ba22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8be705cfb69aa156cb7c0326775dfc56f3e6d6d7d2c8a1e2c1316d57dae2f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7613cc0fcd88a60f7358351833f93958b03fed87a6242e4c3e109770745ecc91"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end
