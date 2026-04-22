class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.7.0.tar.gz"
  sha256 "3c0958ea2a2aa049e5ec47cb0b734db53a4049383482cb3711db2a7efbeb15f2"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "993224da477bc68cc7cd4bb6a63d097c4ca4a466fd10f31483a2cdc0a230bd49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16bbe802355d3bad1ed919a8738f0102e989d7816eea21f7d8fba60eafce847a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ff45e4a0860ac447fb53805e3242116250032792c452d622b94844147326cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a6bafa0fac6c70ef8561424d575a0b9d43fec7701be315320c2355e3f0ed417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b33b0f6ed0e72f49ee7a64dfe738365828e160ff421e1223889cb013fa9a9787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3203a073a94ac9aad1ccab0855fe19e24ce2e9ad3977a88f9b2d3e44df9483e8"
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
