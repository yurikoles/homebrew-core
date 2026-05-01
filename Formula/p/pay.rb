class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.11.0.tar.gz"
  sha256 "2b15a9e3223e447d3a0727928d006e40c26a520beeb7eed596ac95cbf0fa53b3"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa115a7588ab5a694f8fbace2f8c3f89c5ff89065a1f71f83c6e99f09b61560a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac28064307e172b20d7da765091f5c0ae9ecfef27a7896f77ac4975dccabcc57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04664b488d650dd27bc66f9b06cca432df3a17ec6549ef5f70f132290758167b"
    sha256 cellar: :any_skip_relocation, sonoma:        "482019be433f6737986e992f3f43e45dcf4fc2be0f03e9874c9922e2c3d2d813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6063bcefefbe82e72bbe32efa88e5d05729785171a28882a591e7db7bfc08f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813e1c450a002d66e7a151196fcd2efb7ac8ac97e7092424ccd68b1be0401d0c"
  end

  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "python"

  def install
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "no recognized payment protocol"
    assert_match expected, shell_output("#{bin}/pay --output=text fetch https://httpbin.org/status/402 2>&1")
  end
end
