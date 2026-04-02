class CopilotLanguageServer < Formula
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.463.0.tgz"
  sha256 "40f563adc494634e0c567333eeff51ec28f75355cee8c8207e513ec55feb5ad9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0050f0cf89cf86a30f2e19cceae67fdf6d9a706984fdbafbbc807b825548aded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feffbe2efbe9e85bc85dcdcf0fb495d9abd4e9b3e74c08c79c90035267945307"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9b687e6d6100c7011de248b2cc17883de4c6252b9a0d1672d2c39c802b2e93"
    sha256 cellar: :any_skip_relocation, sonoma:        "e722c764ee57eb093e24a49e16cb0086708f790378f93d440a4fcfe5b4f79e0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4815359f75b3f304d5007f981a67d4e78670648b3d90d3444d0c32968085c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dc5867db84198b4a6b6ab1d307975b208eec39373b735cda83422d42e25b8cc"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    pkg = libexec/"lib/node_modules/@github/copilot-language-server"

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    # Prune bundled native artifacts for non-host platforms/architectures.
    rm_r(pkg/"dist/bin")
    pkg.glob("dist/compiled/*").each do |os_dir|
      if os_dir.basename.to_s != os
        rm_r os_dir
        next
      end

      os_dir.children.each do |arch_dir|
        rm_r arch_dir if arch_dir.basename.to_s != arch
      end
    end

    if OS.mac?
      pkg.glob("dist/compiled/darwin/*/kerberos.node").each do |file|
        deuniversalize_machos file
      end
    end
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/copilot-language-server --version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": null,
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"copilot-language-server", "--stdio") do |stdin, stdout, _stderr, wait_thr|
      stdin.write "Content-Length: #{json.bytesize}\r\n\r\n#{json}"
      stdin.close_write

      header = stdout.readline
      assert_match(/^Content-Length: \d+/i, header)

      Process.kill("TERM", wait_thr.pid)
    end
  end
end
