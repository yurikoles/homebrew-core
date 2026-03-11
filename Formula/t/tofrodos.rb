class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://github.com/ChristopherHeng/tofrodos"
  url "https://github.com/ChristopherHeng/tofrodos/archive/refs/tags/1.9.0.tar.gz"
  sha256 "f4e16646a1eca631cb0ba62440b47cb8651ce1e6bd2982e8426d3a98ad8083ec"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9b776268d2a16c1b90af8e737892c3d7d5cf7992e16d4c10f2577b6cd3ab2db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f3e81b2b9f9416c6dacd3ac6726ab17a4a03e0f63e736297a5f62e4428ac2b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9e3f6b98f27b4dadc65ad1e6a1f35af9f9ce2d004119a1f7a49f43ae5cd5456"
    sha256 cellar: :any_skip_relocation, sonoma:        "39d54b14e9575c2e21770604bf6a361d6fbb1943a0ac5e953164c84869f7c144"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "061d7400737cb1ea86aff7de4596a7d69631ceb533e163d40cfc6cb8e3a44b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0ba730bd91559c765b22ddbfae28ea95c00ed5d4f9e354dce511f149251323"
  end

  def install
    mkdir_p [bin, man1]

    system "make", "-f", "makefile.gcc", "all"
    system "make", "-f", "makefile.gcc", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Example text
    EOS

    shell_output("#{bin}/todos -b #{testpath}/test.txt")
    shell_output("#{bin}/fromdos #{testpath}/test.txt")
    assert_equal (testpath/"test.txt").read, (testpath/"test.txt.bak").read
  end
end
