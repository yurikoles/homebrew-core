class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/refs/tags/version_128.tar.gz"
  sha256 "56fd30ce083c5c64a22424e88b559397e208a55c7ac3d31ead2aa059214644e1"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-](\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4580749be85164a917d92c725f38653fbf1bf04e515216fbf3f709d200274a69"
    sha256 cellar: :any,                 arm64_sequoia: "92b95fe77fb08787c418c9cbcba0ff3e864fd65ca719ebcffcfce9e0f4f06ecb"
    sha256 cellar: :any,                 arm64_sonoma:  "bd282924654376058fd786d8ecb9b1cb8f83d791ade6e57ddf01b7cb4f7eaf4f"
    sha256 cellar: :any,                 sonoma:        "cc93c3160cf09f85e5b986f52dd137dd0165b6e4bb9951a847eb5180aa6dccc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f1572bfc793e6e9b78069ab9434ffe8132c2d659b3885c48d60ddd278b703c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c7994964ae9ea772f763313e5ba670f3b3117148c983041165bac8b3c9905d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTS=false", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/"
  end

  test do
    system bin/"wasm-opt", "-O", pkgshare/"test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", (testpath/"1.wast").read
  end
end
