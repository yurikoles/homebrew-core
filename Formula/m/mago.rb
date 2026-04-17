class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.21.0/source-code.tar.gz"
  sha256 "71b4c4aa320d628e7ad6bc23dd80ae0e0c58eb03d7febadfe27d26a96514355f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "951b8ffc8e9914e107591b3a515a1515a7294bc8442a5ace0236c2e1afbb4707"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de12492ed30235c7bd9071462fb8844ac450c295adaff45e3f3d926776fbc7a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd91503c2d18ef0975493d08f81ea32b17420405b0e8099bba9710ea58b96abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f413d9af3375e4c1cc4e0eabf99c2fa477c60c540e923bbe6fbfb736d3c47653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54ab5efe9ebd58f8a7c01223504ea6314aa44bea0484ba355da719d252cb4a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7764fbd2b0dd15294e308a88c2a63eb8c343f3445081377f0584bfca59210c4f"
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
