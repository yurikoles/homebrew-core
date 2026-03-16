class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "fd7e20923e8f748803d54d9e0fabf44a44c748822a65062999e4b7edec6b8da6"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d50c5de41c6df81a8e4a0a9dc3885f2c13f69fa1652753e43d24ea0b90776f15"
    sha256 cellar: :any,                 arm64_sequoia: "d7cfcc49f9ae330fa3b3b160018503f9d115843f5502b3a19184e8db0e486460"
    sha256 cellar: :any,                 arm64_sonoma:  "99fefee4068b522aa2c67a235dfb867e6a64b865b769315e764ff5d6961e9773"
    sha256 cellar: :any,                 sonoma:        "9261d9df59e96ac0eb5c5c2214aa7a9332eb62998d0dd1b0cbb0293cd8a19109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43fac09e8bc7110ea1a5f43079ed1eb7081e9078ebc2bf17916a2a5a73ebc0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc5af9082ad3cd2e0d778026b02838c2f65677d1fc8d1cbcf09df5f809182ca"
  end

  depends_on "highway"
  depends_on "isa-l"
  depends_on "libdeflate"

  # Remove forced Linux static linking, upstream pr ref, https://github.com/OpenGene/fastp/pull/667
  patch do
    url "https://github.com/chenrui333/fastp/commit/b86119e07253b86d161d18cfcd46815a78a328d8.patch?full_index=1"
    sha256 "3ac491369f4354a895312cddce82ea2b8aa02bb52c4f5b9c040cc3d8cfaeeb58"
  end

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
