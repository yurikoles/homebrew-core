class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.25.0/source-code.tar.gz"
  sha256 "3598286b1ebdd812fa57b056b49ddaf9def10d8e383f0acc6555eab5f841484b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18f0f0bb2e2f656eecd39a61c49e778b28c162c582995418e5afc04e0d4cb299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1b0314150f11f4a97dba908b3339b645b43dd4d99ee7764504caa4cd8fbafa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f76898dfb28b16b46415fd20e0114bd300fbc21a0d2471ae273ded0c7b22e169"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c6266d30780485e44db78cb30b2dca4256f05d80402402efb5932e27d118f57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f226d052bd78433033a6e13a6a0f77aa5b4a8c2afc88b0b1a7b6b04d22948444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31d4ffc666a9af27673244fb08a297249c498ef0c8d3f11ff9b06c1c0532ddaa"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
