class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2026.01.tar.bz2"
  sha256 "b60d5865cefdbc75da8da4156c56c458e00de75a49b80c1a2e58a96e30ad0d54"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c10457ea0b85206900f4f13fb26a2d849f7515ba196fdea3824cd748b8c1abb8"
    sha256 cellar: :any,                 arm64_sequoia: "23d9bfd4e25d14b36653de63d348dbce494abcf8d2678ee19c26091f160fcbf6"
    sha256 cellar: :any,                 arm64_sonoma:  "9a4b46a4529ed0a972f947b1ffdaf1f551f985f0233f27b854577d2531d65509"
    sha256 cellar: :any,                 sonoma:        "4e8a2e26723044930803c88a92dc78311b304d59d4141fa0af511db7afca3f27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cab804bdf8d0ac94a1f66e23f2348dd93c1bbeb27cb68f0d7666378687108ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf55d572e176b78f7db2b095da1e5354049628ea26fed798c36f9482bf6669f8"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Replace keyword not present in make 3.81
    inreplace "Makefile", "undefine MK_ARCH", "unexport MK_ARCH"

    # Disable mkeficapsule
    inreplace "configs/tools-only_defconfig", "CONFIG_TOOLS_MKEFICAPSULE=y", "CONFIG_TOOLS_MKEFICAPSULE=n"

    system "make", "tools-only_defconfig"
    system "make", "tools-only", "NO_SDL=1"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    bin.install "tools/mkenvimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
    system bin/"mkenvimage", "-V"
  end
end
