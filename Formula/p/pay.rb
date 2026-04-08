class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.4.0.tar.gz"
  sha256 "63f0cc9535214a16ab3fa3d546a1d83d01114e46677605d74c4e6a1f04264d96"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f87eb967163bf8edcd83fb4c62c59796fa2bada3917ec64b3e1eed1b210aa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee6c58b393fbae826dddc3831b5c8b9746568398760fc1748f8cf0aa12cb287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c57a13c735b574df5908022fd56f56b5c5b91e3659509ec3b46df4eee4236e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04cf8eb3490f7c0170c47b6f68369dc7097d4fdfc8a6444918d8c43119be771"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f15123a92ab5eba29b5de1e7f4d0484c04d25f7bd14b4def152e6fc96e54fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "273a428f8a630a8eada4920e8a8afde02698705111b1c42c0cce1c87f2ea4519"
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
