class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "9bf9eed242b88e0997363cf24db3d0865e867074d34b194d3c2411629cfe0c37"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e08ba8220b2f56523e36d17ab246fd11a7c3042b89f17d7d10eb9d050c2780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86b0e8a48baa499d117bbf8b1c71a902513f925364880171473a809121200f38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8378dc1a40566e5cbd3e157b10413781148ed131b7513323158af26d9b8bdd5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ec2e5c25ad718ac4d2aa799850a5047cf241db0da7595088cc835c1a08b7f15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42056cadbbf72436cd158ab56626a7dc329376bc1e8bd8efdce639c95b4a1474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfe8799d11d84c3fed3f613d114e7925339b573bd390521d9a93479686b9f44"
  end

  depends_on "rust" => :build

  def install
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-ld_classic" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/rustledger")
    system "cargo", "install", *std_cargo_args(path: "crates/rustledger-lsp")

    generate_completions_from_executable(bin/"rledger", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rledger --version")

    (testpath/"test.beancount").write <<~BEANCOUNT
      option "operating_currency" "USD"

      2024-01-01 open Assets:Bank:Checking USD
      2024-01-01 open Expenses:Food USD
      2024-01-01 open Equity:Opening-Balances USD

      2024-01-01 * "Opening Balance"
        Assets:Bank:Checking  1000.00 USD
        Equity:Opening-Balances

      2024-01-15 * "Grocery Store" "Weekly groceries"
        Expenses:Food  50.00 USD
        Assets:Bank:Checking
    BEANCOUNT

    system bin/"rledger", "check", testpath/"test.beancount"

    output = shell_output("#{bin}/rledger query #{testpath/"test.beancount"} \"SELECT account, sum(position)\"")
    assert_match "Assets:Bank:Checking", output
  end
end
