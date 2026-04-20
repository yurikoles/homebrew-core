class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://github.com/ChristopherHeng/tofrodos"
  url "https://github.com/ChristopherHeng/tofrodos/archive/refs/tags/2.1.1.tar.gz"
  sha256 "77e6855917e5dd04ff445b6de3f8373531af15b2cb70e3b29058658f9d495c06"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c7a027d80fc364549efdb9e0a76a8805af869088a78556d857e1af913ad1cc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff2ad7739ba8094a33b04811762e3ea7b2fe429832b64bbb512f3e9e0d34cb7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74ea91c0ae621e297b386903e16158887f6a283a3abca4b9147b3b69cb8b46bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8154cbd076e3ea795852d2978890a77e8255970f745de0cb52b6e262e184c497"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "145f5ede93d2c0af8b8b5896766f4cf7ad362ffc0fa01a1014b4196a01cbd6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb5d402270410856a8aca0c5a6b1489a24e015dcdfdb43c3c9c7f542eff5b428"
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
