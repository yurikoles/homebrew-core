class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.1.4.tgz"
  sha256 "1b766b9d43f44149e0afcbc366aff75284a5b38957d34f9a434bd475e046bc0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1f2982ff58c88d40b0fab3426b4d9e38e09647e875d4831fa8e5d06d448a3ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
  end
end
