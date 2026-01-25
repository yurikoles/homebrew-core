class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://github.com/polarmutex/beancount-language-server/archive/refs/tags/1.8.0.tar.gz"
  sha256 "fbfd44a54337818b76425f45e89363e7635a7791f027254169ed28dc939f0973"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bd725c825810698d874f715b45021b7af537716294fd429381b7249d158998c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9321cd995d440c7310aee65b74d55553fc4cc629f22d50d30a42a8572100a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0002884953ee2d2637950716196d730fca696f72f8d1c7081b04066102bc03a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c631250ee10eeb5260d72fb8015d58190267c10fd031c5a40c5a135bb209d24a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e014bd68d4178cb76f07dbb4fde3259fbbd8ed1033eb4020c040f01669b047a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f22744bbacc4b4d4ea6f504d68922f5fa8095615f1ea3f6f54b61096041a7245"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/lsp")
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"beancount-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end

    assert_match version.to_s, shell_output("#{bin}/beancount-language-server --version")
  end
end
