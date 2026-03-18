class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.59.tar.gz"
  sha256 "fa529da8707c4e6fa24d813eaf895dc2616c2a5871b39a8a8c0973fbf93e1c40"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5876098354693e497008da87290c1e4d70ec063a11f7014f3850a84d4061d6dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6acb250fdd86af09f3e0bb84541ed46213ff69e774f5f42fd8b07f7c5add6f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1abe224e44671062cce45490395d4a2a9ac304e72879ccd0e8f75d295d407880"
    sha256 cellar: :any_skip_relocation, sonoma:        "29a920cc2e0bf7c9c72804088c55a4a9efbd2a131286c63536c5096868630505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5a54d4fa9442c0d397aec67ac5109662603a721a1b457d0968edff967f82afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1e2dfe485cddc95bd4de0a7b4a28c316e1e3338c0f5d3636536edcf469a1e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/containers/kubernetes-mcp-server/pkg/version.CommitHash=#{tap.user}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.BuildTime=#{time.iso8601}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kubernetes-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubernetes-mcp-server --version")

    kubeconfig = testpath/"kubeconfig"
    kubeconfig.write <<~YAML
      apiVersion: v1
      kind: Config
      clusters:
      - cluster:
          server: https://localhost:6443
          insecure-skip-tls-verify: true
        name: test-cluster
      contexts:
      - context:
          cluster: test-cluster
          user: test-user
        name: test-context
      current-context: test-context
      users:
      - name: test-user
        user:
          token: test-token
    YAML

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = shell_output("(echo '#{json}'; sleep 1) | #{bin}/kubernetes-mcp-server --kubeconfig #{kubeconfig} 2>&1")
    assert_match "Get the current Kubernetes configuration content as a kubeconfig YAML", output
  end
end
