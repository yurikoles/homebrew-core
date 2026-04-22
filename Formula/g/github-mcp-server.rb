class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "3e3b84ce19fe6138bc74f8ad338e2de18c72614d5dcf09a702f8bd37b6b6cddd"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c5db8a34acd8a175238492334789c571a3602fbc4f4c75dafe9f8e0ca6d7d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c5db8a34acd8a175238492334789c571a3602fbc4f4c75dafe9f8e0ca6d7d99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c5db8a34acd8a175238492334789c571a3602fbc4f4c75dafe9f8e0ca6d7d99"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e2f9936bc26086d51a7958c823ac0aaf032ae3f5aa99b7b93ccda6276f74d1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "925ae94aaa92b5100e5d022503b5cfd6309628289cdf5325b4bb8112005ee64d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4a6a280eb2218279cf611f8709f700d48ce18e88cfce219f686acdf316bceb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
