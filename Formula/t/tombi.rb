class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.20.tar.gz"
  sha256 "a137dfc380aa22c7ac156c99600d1b45680fc1b88c0e68cf11aea8589d919c5a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d703723ec229faac0a958517fb22e7644ef1ab2381209fca4eb55826b9d313e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe1d9eb73e5247651515b23bd5140a374a46c88de7b4225b9d041ec5be91e8dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08cbfc54ad135545c03d72b907b7bfbbc47e80e368303ac3177b3c732b438670"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c35a0e23834cc8dfc86c8bc0a2f7cf134d9d7ef904d848f736034c432595d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c99ef0e86c4ff776c15eb692b344e750cb1b45dc9fff00a914a8b9aaff2449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f294ccb5a90ea2285a64f667e74cb5b448992ddcd27865942c520b2d0391b80"
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
