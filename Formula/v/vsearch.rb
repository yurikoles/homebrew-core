class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/refs/tags/v2.30.6.tar.gz"
  sha256 "6aa4d7f5ad07774d8e3477bc9e17a91d182f5b7f92c04e43d1bc09d539086d34"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "061a632b178e86cf1e74cc3ce4dd1d9932e7e714e5075014420c6fc67f7e2e3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3ba9402d07da8d502f4f3bf87405302efb7634476ddfc06a20f83b000802474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f0d4f77da3187d3fc95cd1753bf890da782467ab44e3d27519cb94479c16dfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d401c88afc8a922672b6b1605f0d06bd8deaaa068f85777450fca3695787e24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef76b11af121aa59337a2c12eb43eae9eb79b89b82f964146b23a7d4b6261290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e3f64285719a49441021c224d1ee559ae12dd43c3df0e66cb2417e067249df"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"vsearch", "--rereplicate", "test.fasta", "--output", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
