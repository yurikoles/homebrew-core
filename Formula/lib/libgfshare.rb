class Libgfshare < Formula
  desc "Library for sharing secrets"
  homepage "https://github.com/kinnison/libgfshare"
  url "https://github.com/kinnison/libgfshare/archive/refs/tags/2.0.0.tar.gz"
  sha256 "91d7ea7f3e5ddb3854a38827a3f6ea7c597db03067735dc953bd31c5b90f9930"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "03c3d5940533347a32f937380585a7d501783d97ff8161a3b8b72a41d4ec8ce7"
    sha256 cellar: :any,                 arm64_sequoia:  "cb19a495ba9032a4bd0e0c5e52bf818c8283af8b29dcb25a0a2f9bb0338c2880"
    sha256 cellar: :any,                 arm64_sonoma:   "661368852f131d75f48672074dd635d04c95f30f61f1adae25c26db2cdc45dcc"
    sha256 cellar: :any,                 arm64_ventura:  "ff95631a45cf14842a1cb98a7496022a886360fad2d4a9bae3154ebd6113726a"
    sha256 cellar: :any,                 arm64_monterey: "0890a2e8ac99ea0497d467e1ab82bb8fe7a34d0f5cd75c01897f15b12ac65211"
    sha256 cellar: :any,                 arm64_big_sur:  "d8fc2d9c78a69fc3fe30913aeaa6f1dbeea7091d78d50bd6e6fafcf4dc6dc212"
    sha256 cellar: :any,                 sonoma:         "a8a4279f842d2809488dc30fe2ba7509412d0304e2d6f32e125ac80bf683f5cc"
    sha256 cellar: :any,                 ventura:        "72816d2d02cec8f669f242e020e7b2980d9f16f51d8e388b57d77c5257a2775d"
    sha256 cellar: :any,                 monterey:       "72af5816492ac0696211008f72b896eee5485c0227964c7eae8caadba28212d4"
    sha256 cellar: :any,                 big_sur:        "619b6bee51163d432b903899d6d86223824e055124ead1856bc6c4399fef4fca"
    sha256 cellar: :any,                 catalina:       "59d6afbdff08b3b457ae3bf6284859eb200929dbcf38c7a2e4f6025a45fe02dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "681eacdb672caf8dd195c5bb9bf891e5bb7c1317eb84e0e81faf1b155dd474ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4439a61e14f81e80009ad0e85a4e2a8183c106161d29e232176faa061ba380ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-linker-optimisations",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "test.in"
    system bin/"gfsplit", "test.in"
    system bin/"gfcombine test.in.*"
  end
end
