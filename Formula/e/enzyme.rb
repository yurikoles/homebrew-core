class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.241.tar.gz"
  sha256 "1e5104e950c8cb141a18deb2a2011e133f659e95ef6c221ce89b054aa68343bb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e682ef308e9b91f23a1681f5187462178ef92a3388b00846c47baf511d592526"
    sha256 cellar: :any,                 arm64_sequoia: "2c435e4387e63c294b3c7342b62a4bf3f7176ce82eb912854b9ca71ab6f02688"
    sha256 cellar: :any,                 arm64_sonoma:  "7e623af75e3cee729e22add1640685b7f41186a8a3445d3b5698e2bd3aca696d"
    sha256 cellar: :any,                 sonoma:        "3f0523f0e8c071f049234d524cb75f75326ba985b2f1bab85921ac3b07b72732"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1732dfbf7d4b6247e78fc1c9cc0ae1787fa12d25b4071d2076f9c495d2ebc894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35b2c6f22e54270e6ccc77f85232ac160b0c4c54f2da9019669198295f601ebd"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
