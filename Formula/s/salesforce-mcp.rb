class SalesforceMcp < Formula
  desc "MCP Server for interacting with Salesforce instances"
  homepage "https://github.com/salesforcecli/mcp"
  url "https://registry.npmjs.org/@salesforce/mcp/-/mcp-0.30.6.tgz"
  sha256 "1828050475d763a5ee72aae8d30556943884f6bd02dfc0d1d3f621838782e488"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12e650168f206b937bcc095559ef13e022bc304ae7162624b0d23b7b1c0be8e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sf-mcp-server --version 2>&1")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/sf-mcp-server --orgs DEFAULT_TARGET_ORG --toolsets all 2>&1", json, 0)
    assert_match "The username or alias for the Salesforce org to run this tool against", output
  end
end
