class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "70b3d4309f1fd0075bd1b6ef592a5e45b66fd0dc2a95a8b986205095cfd78689"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f525a1621061eb05d3f1acc5565d20bcc6be204da5635e3543120d090b5b7f4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e20a804c08404d24f70b0c410a53e9863711063724a4bc77ddd9c1376533b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580a798bbb2676b4f3e66f55e2078c3f7d4db2d9fe185749e8cbf4ddb769eda7"
    sha256 cellar: :any_skip_relocation, sonoma:        "43bd6a73abaad903eb5e9e6786b252b777e8df2d0b29eea942bc8fc102c41d6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efad12ecaea7456372e70f2a295a546a4721eb89f4b7f6c9ba91041f8f13360d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7b962af0fdc1b5968759996510cbca30e9f3baa79a8ec38fb772cccf7bed47"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
