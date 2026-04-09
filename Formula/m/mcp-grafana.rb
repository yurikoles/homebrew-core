class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "fd4e0c53017ceb717e769cb3d419d1e8672df65dd860172f09f565ba06818dd6"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9173c635fb382a5860edf85a4d41073f82dcbfca47d954102e81f7e8c4d6c2ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bba3ed1f974a13af5ba4a2edc52c13cf9f594373a7a6c1cb9201096db2540c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2fa14431e8d572ffb32da66b14d3e43547e263530fb379226c2bf290540da79"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb3ac57dee47f3e8ef4b1ffaf666724abc6528b43ef07a57bf9a4d0070eaecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f02009284ac73159d69199af1bf3982005a2039c498b8b21c808d9a1c40a53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3349bb02088c7307f85969b31a32482a48db8880902d5bf5e11eb013a00607a0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end
