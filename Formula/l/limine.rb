class Limine < Formula
  desc "Modern, advanced, portable, multiprotocol bootloader and boot manager"
  homepage "https://github.com/Limine-Bootloader/Limine"
  url "https://github.com/Limine-Bootloader/Limine/releases/download/v12.0.0/limine-12.0.0.tar.gz"
  sha256 "2546120f92da74ceddc882d1316c4a56c0eec9e931ec3396206adcc22850a543"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "595cd155ceaa4fd2193cc9b2718af2407d079b65c88d19e484fa1c669896e771"
    sha256 arm64_sequoia: "a8070a81edcfb9a3ab8b0ad80f905c5603f78cafaa7f615733b9bd83c1fc498c"
    sha256 arm64_sonoma:  "d8f64e9b205e88486bd691c63401936267b2ff67889ebe3759b0f263fff659c5"
    sha256 sonoma:        "5a6864cba2bca47545d33898e12ee16b1b8c772d1d1f617b5840b37581430a57"
    sha256 arm64_linux:   "3e7f9471a142dd587806c641b30fea8bcf1a81ed64b88511697d59476c135353"
    sha256 x86_64_linux:  "fa486e230c931c552c3b023fc8e6f24808de0101099670516291c6149538f9ca"
  end

  # The reason to have LLVM and LLD as dependencies here is because building the
  # bootloader is essentially decoupled from building any other normal host program;
  # the compiler, LLVM tools, and linker are used similarly as any other generator
  # creating any other non-program/library data file would be.
  # Adding LLVM and LLD ensures they are present and that they are at their most
  # updated version (unlike the host macOS LLVM which usually is not).
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "mtools" => :build
  depends_on "nasm" => :build

  def install
    # Homebrew LLVM is not in path by default. Get the path to it, and override the
    # build system's defaults for the target tools.
    llvm_bins = Formula["llvm"].opt_bin

    system "./configure", *std_configure_args, "--enable-all",
           "TOOLCHAIN_FOR_TARGET=#{llvm_bins}/llvm-",
           "CC_FOR_TARGET=#{llvm_bins}/clang",
           "LD_FOR_TARGET=ld.lld"
    system "make"
    system "make", "install"
  end

  test do
    bytes = 8 * 1024 * 1024 # 8M in bytes
    (testpath/"test.img").write("\0" * bytes)
    output = shell_output("#{bin}/limine bios-install #{testpath}/test.img 2>&1")
    assert_match "installed successfully", output
  end
end
