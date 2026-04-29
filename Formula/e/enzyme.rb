class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.257.tar.gz"
  sha256 "9345b5353ecbaccdc1b3445f153856a9f67179fdaa680fe6dc610383bb30a7ca"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9dc789659cd585175f46894041aea9358b26887482947212f5063d628378e40d"
    sha256 cellar: :any,                 arm64_sequoia: "42c0f2cb40fff8524559ca24d28e0c80e648d7d7abf03be18684733fc7bf7f37"
    sha256 cellar: :any,                 arm64_sonoma:  "0b64fccdecec0cf505d7c63eb285fe6ba29cfdcc2be42b20c14cc79d3bb0868b"
    sha256 cellar: :any,                 sonoma:        "8390f3789cee9c3a5b820c3142b2f946f3544c63fe92f2cd6d9150b4ce93cdf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ef06dd455f26993a71024313609da5745c8fc6555a0121c8218d1f3e08c8cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9255aeba240806231b0a200bed1970fc2777db013f18a66860e0ecfcc5f21a3"
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
