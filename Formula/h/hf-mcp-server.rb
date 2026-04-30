class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.11.tgz"
  sha256 "8cf1d575d636afac1082c8e67900027473f515340aff1adc502986b6484db84e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f82da34098848257096b6f7a480cf8a3ea397bb5ad67813b26d331ba8e300b0"
    sha256 cellar: :any,                 arm64_sequoia: "8ef5707229f72453a12314ca28d081353b0818eafa62127fe11f9e89eb31b87a"
    sha256 cellar: :any,                 arm64_sonoma:  "8ef5707229f72453a12314ca28d081353b0818eafa62127fe11f9e89eb31b87a"
    sha256 cellar: :any,                 sonoma:        "0fb002798f6ccaeeaaad96e216d61b4c5fe43e52724bdce3f8f86593702130f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9394bd021d281801f710792bc95fbc05ececb71a4d44ff74a9f8f202101974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d06ec8d05e899727ff98b2835c5d262c411852f4caf03a31b1687b92d2922273"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
