class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https://github.com/awslabs/diagram-as-code"
  url "https://github.com/awslabs/diagram-as-code/archive/refs/tags/v0.23.tar.gz"
  sha256 "df8f9ca155ec84e26db6f2060b20cda2e2d5b81d990ae96e7b26a006bee8fb33"
  license "Apache-2.0"
  head "https://github.com/awslabs/diagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4609266e567991f0a6336fbf63eb20a6a87e4ad47890dcc177fa7a0a4a999de0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4609266e567991f0a6336fbf63eb20a6a87e4ad47890dcc177fa7a0a4a999de0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4609266e567991f0a6336fbf63eb20a6a87e4ad47890dcc177fa7a0a4a999de0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7be1fe4983eb49c41c02bedd796e255a4012c6371814b5ce1cfa9522416f2fea"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https://github.com/awslabs/diagram-as-code/issues/12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/awsdac"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin/"awsdac-mcp-server"), "./cmd/awsdac-mcp-server"

    pkgshare.install "examples/alb-ec2.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awsdac --version")

    cp pkgshare/"alb-ec2.yaml", testpath/"test.yaml"
    expected = "[Completed] AWS infrastructure diagram generated: output.png"
    assert_equal expected, shell_output("#{bin}/awsdac test.yaml").strip

    # Test awsdac-mcp-server with MCP protocol
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"awsdac-mcp-server", json, 0)
    assert_match "Generate AWS architecture diagrams", output
  end
end
