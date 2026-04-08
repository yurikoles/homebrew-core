class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.96.tar.gz"
  sha256 "abeaf2c8fd607f2c45816a4ddd34f2d0a10d49e1f41f52929b8e67a0cdc24368"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "256322de9c6c640d565711c2a4bff7c5c8af090cc723800e436e27a97357d1ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58ccb2c3137e46244853c90ae46c256c38472c98186978235aba87d0f051ed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af1a30f95a3b81d95dc0cade3a0a664095aab7cbb8213fd7d9f6f05e87607ed6"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb6d21a29eb7e069c258f8274cb28bfce32c797265fc8f5ca3626017f5a87e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d11e5a0864bacac1afab1f673604fc311ed3e2ddb764009518dd2b336e28cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9899bd9a5a8e82eecdfb101cbd165d50354f08c579785448b2fffdf22d5f411"
  end

  uses_from_macos "libpcap"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1", 1)
    assert_match(/LFT: (insufficient privileges|Failed to activate capture on device)/, output)
  end
end
