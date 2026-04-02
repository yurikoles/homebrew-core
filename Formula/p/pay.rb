class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.2.0.tar.gz"
  sha256 "486277c69cebe234a271d98e4c1063e2479154acf0013989b0cdd9b92caaf328"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e12fa0878a5f2342b6c7486d045b56fd718fc93950a86d14d73615a372e4345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d92019d76a02f074ba0b42ba16b6f730d548cd248a73fc8f0e457e38873f9a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f1de6190f4e79e4c8d9a4104d5e2309de631c2aeb5ddc1c2ef846872a43f946"
    sha256 cellar: :any_skip_relocation, sonoma:        "350c2b0ecccde364f20cd0db44e96aa22fa1d0cbb37dd41be5806b5ce88d7167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "087af8855d81d1a24a429e177764167ecb5af96a73a3fec409c127e4748417e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e07afbb5349911a4e0818e52dfe9b14340120feb20d1f2faf5e1549bd332144c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match "No wallet configured", shell_output("#{bin}/pay fetch https://httpbin.org/get 2>&1", 1)
  end
end
