class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "https://vpcs.sourceforge.net/"
  url "https://github.com/GNS3/vpcs/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "73018c923fdb8bbd7d76ddf4877bb7b3babbabed014f409f6b78a2e2b0a33da7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "158636f42e7e2b5c9bb55093d13dcedeb7513c17a003a3432741acde18e4402f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c720c9b26f940276b3431e88b4c8ce29cbe2fe616536d0b8419a6e378e09c3af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a6670a2833658d64a9be4c0e42f07b7224ef2cf1ea50faafa982f8469a49052"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ad3049e60f55965753362c2d6b5d5919dbe4b5537b155a0d914614d4a0d8cf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a039b6f432de6fe7fb3429b6ccad3a822e1249e6b11a3af0d916c98a908b4dc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d673e17698f476b16e70b66227623b829779846d0f4b2246cf84c85f8427d8de"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d359b2fa18ff5dc0f8a1f34ef372d1d721fcc4400bf935ef743368a7ec05cf4"
    sha256 cellar: :any_skip_relocation, ventura:        "c65377d546fbe8026e2a833918b2ef9cf10578a05f6f6f7a0141aa264b4875ef"
    sha256 cellar: :any_skip_relocation, monterey:       "6f3e52b8fd8ee4aab736d67fc99ed39fc72364fa9a3ffc9db1b8bd0d8b27661f"
    sha256 cellar: :any_skip_relocation, big_sur:        "75d81877dc7c7e8a07b5a1496e1264ac19fd8206f5dcc24de835931a0d1501eb"
    sha256 cellar: :any_skip_relocation, catalina:       "180a02cc1bb06bb9e5f441688d6b1a51e5c531cd6dea68399aba55f3c5691dd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5de5fc1e177ac3651f6c1ea17097307535b8735757ded9e3f693458db2e86827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee66bd58892962238c81873d186c5066fd53490328b2c0db6667532565db008"
  end

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "make", "-C", "src", "-f", "Makefile.#{os}"
    bin.install "src/vpcs"
  end

  test do
    system bin/"vpcs", "--version"
  end
end
