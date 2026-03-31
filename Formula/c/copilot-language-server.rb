class CopilotLanguageServer < Formula
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.460.0.tgz"
  sha256 "de1d6e2b2a1128e3590d46352ee3734196a84ff3e4cca180322c1c5cf7f829b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087dfef06c8aecef7a1ebb00fdd69c7aaf303860fdefb5704ce0dcbffa564e52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362ea3a531682671106db664c5c8170a9c845ec1a4e2e470639c65e67a39eb95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f1498a81c835bd30f947120ee9834e828c645182d16969e7446fea1247742c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e55463bbb4b03ca9ef78e23b4c4456983760499b258ba07780c2ccdf2d61291c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c8423e49ccb89ec180e9709ee167aa075ca66920042012023c59326a679b43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "369983a2f906df25180c35e91d10596f43e09c4f867f04356254b44fcf70d4d9"
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
