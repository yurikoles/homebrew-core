class Zydis < Formula
  desc "Fast and lightweight x86/x86_64 disassembler library"
  homepage "https://zydis.re"
  url "https://github.com/zyantific/zydis/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "45c6d4d499a1cc80780f7834747c637509777c01dca1e98c5e7c0bfaccdb1514"
  license "MIT"
  head "https://github.com/zyantific/zydis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79b00be9f9a41dc1ba17f76b0b7ad4017db140c44076666d210f1bbd50a6fcc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f925b7d0345acb686c8e62409639b866e7a1123e1209508de02393d5e7af0bee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a59d5b51d0d85f0a7d4970e9e1f9c88a4e70d1f2edb032954ef841868ac3e4c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae399b5f60c5d4bda9a1423990471f8dd13f53dafedffcba423fa911d89265d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f1bd1d7a92035759a01a25a9c2e7657e5c7a6a0c64d121ca3821dd0d5bf6c26"
    sha256 cellar: :any_skip_relocation, ventura:       "9cef22740cd31a9e97983504c80eddfb4201860fccbe6887dd9692577ea7897d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b2f83673880c27fbbdf90ca73ca1d5cf2777727f188a0d18dd6b2d9849e1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57fa80a8a5f5de2515de7c9e0ec1df9c29bed0035716ca4abd64fadbc1e868ce"
  end

  depends_on "cmake" => :build
  depends_on "ronn-ng" => :build
  depends_on "zycore-c"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DZYAN_SYSTEM_ZYCORE=ON
      -DZYDIS_BUILD_MAN=ON
      -DZYDIS_BUILD_SHARED_LIB=ON
      -DZYDIS_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/EncodeMov.c"
  end

  test do
    output = shell_output("#{bin}/ZydisInfo -64 66 3E 65 2E F0 F2 F3 48 01 A4 98 2C 01 00 00")
    assert_match "xrelease lock add qword ptr gs:[rax+rbx*4+0x12C], rsp", output

    system ENV.cc, pkgshare/"examples/EncodeMov.c", "-o", "test", "-L#{lib}", "-lZydis"
    assert_equal "48 C7 C0 37 13 00 00", shell_output("./test").strip
  end
end
