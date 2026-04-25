class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "29a638f890b71a73d55c73096cf7abf037ea9b75f69df83c553e6722d1c3a06c"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e3d3d57234438be29ac939a086e94e05a0d53b86beaa904af04e6ee9576e631"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3d3d57234438be29ac939a086e94e05a0d53b86beaa904af04e6ee9576e631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e3d3d57234438be29ac939a086e94e05a0d53b86beaa904af04e6ee9576e631"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4acff2febe1b26cd697e2f343ae4ed2a03c8a344b8666c112afc234a98123b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c256fde9d009be2cf5b204db68fd05b5d050159a4091c7f9f9146174f8843f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7af4f20098aff4538edd21c924c54098d5fb027b0986a9811d8347256845fc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "com.example/mcp-publisher-test-", (testpath/"server.json").read
  end
end
