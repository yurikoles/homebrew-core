class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.3.1/xmount-1.3.1.tar.bz2"
  sha256 "422185f1b99ec9e1077201a3a8587fa850068138d1ce685f636305bd19b7a71a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_linux:  "4c74f5c52e9062ee34d3159d35725a808a084a350eaaccb3584dacd8ec91edc3"
    sha256 x86_64_linux: "769d0e284fe04e47c8074df8cff9b31fd5781055b0397dd35fa6aba6e9db5cc8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"xmount", "--version"
  end
end
