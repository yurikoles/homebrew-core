class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c55656dfe9c3a40d3da59d680aa4ff4a2a4861bbc3993cb3659cdeb5e23fd858"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b02fa8eb605f94a974f37b89724a6c00761867bb64991febf9e1ade48a978d27"
    sha256 cellar: :any,                 arm64_sequoia: "a60acfa9d9c2ac218fcf2aa84f95c2b0ab496ba808c692938db33f0780976d14"
    sha256 cellar: :any,                 arm64_sonoma:  "0c6bfce83397202a958d5d55a85a1162fdcd28fe4fc40ab4286495786da1408b"
    sha256 cellar: :any,                 sonoma:        "bb3d842ea702ec3abd214bffd5206b7a04bb1ee9f862af60a4db81e06b9591a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "771b3d74c74f777203e479b5a57bfd5c02555622b34fa22822d441cd64c4953d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01cb3eda27cbfcc940d1499dac5d1a8962b5bca60f3eaa5e0ff47fe3e0ef53ac"
  end

  depends_on "highway"
  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin/"fastp", "-i", pkgshare/"testdata/R1.fq", "-o", "out.fq"
    assert_path_exists testpath/"out.fq"
  end
end
