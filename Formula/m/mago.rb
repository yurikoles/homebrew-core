class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  # github tarball has issue, https://github.com/carthage-software/mago/issues/794
  url "https://static.crates.io/crates/mago/mago-1.2.1.crate"
  sha256 "131022f44bd34625c3e711b77a9122aa79785c37149207781c72b9d61b533a9c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "900eecd9bbcd67d4df7e3ddb72ce1c747ff8fa9616c1a57a40a05d69cbe1dd33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5edc1fe7bcf436bcf3a74ce5db6f74e6b96bdcb1669797d9fba671d8cc24183a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e07234aa026fabd935a6f57e8a0bf51642ff394416ea9f4581c73112d0429b03"
    sha256 cellar: :any_skip_relocation, sonoma:        "15a5f43ab70194992af69f55f9904ce5155296546e3b088eda45eafff6768061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "566211bdb22372c1540e46d6a6ba24444fc8361a8c20547f16512c4f11b1aa41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3638aeb3f37f5c61e83c8f3f208b256f29f2282a49fd7f645240886b907b1e62"
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
    assert_match " Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
