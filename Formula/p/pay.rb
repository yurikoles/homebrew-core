class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.7.3.tar.gz"
  sha256 "959db9d062fd2f637a1f669a106e96c3c432c9a25a675753e5b39cce73b2802b"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c94f5a6deaee0a154e0c84b969d33858ac3d83f8dcd02a039ba790b97128ec29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47fb00a00d22ff882f91fec8940444e3bb912603ed1f66980c9fdfe513626225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c0e76525e7c26d8dea3718bc35752db47d15d8de534fcc727e0134e01601ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "163490f576d2186572c191d4b7a16ed66f4e984d5ae467b04215b9cbcab70026"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90a64b7ee9d626f2269170fda7989c6f9f7e6735eb48d0ec97f9a68bd6bd0549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74e6444fdcde21df23814e2cfd2aa58027c1422e3d269d4bdcb076e25ca0654"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "no recognized payment protocol"
    assert_match expected, shell_output("#{bin}/pay --output=text fetch https://httpbin.org/status/402 2>&1")
  end
end
