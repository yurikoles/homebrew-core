class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "https://basex.org"
  url "https://files.basex.org/releases/12.2/BaseX122.zip"
  version "12.2"
  sha256 "cc3e9a615608ac5eac643e51e8d341487f061a029f0cfbacf73b015adbfe3b2c"
  license "BSD-3-Clause"

  livecheck do
    url "https://basex.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/BaseX[._-]?v?(\d+(?:\.\d+)*)\.zip}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83e58918742e40f4d4fbfdc1f0854668048438b9ad02ff503f96371ccb26338b"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    rm_r("repo")
    rm_r("data")
    rm_r("etc")

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
