class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.4.tgz"
  sha256 "4b50cc84a15c26b1899c89f54f7aa9698bd4d6634c133f83c1e9c41135d61616"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bc8b2145cbf0cfc70a7e2835e2c21ae5d2cba946517720d3b690544f5b8b8c4"
    sha256 cellar: :any,                 arm64_sequoia: "94d917c566a4ac656af5ac309ca968078c33731ba971ff156d93c1a54ccd058b"
    sha256 cellar: :any,                 arm64_sonoma:  "94d917c566a4ac656af5ac309ca968078c33731ba971ff156d93c1a54ccd058b"
    sha256 cellar: :any,                 sonoma:        "21ab9be3b48ea07d11154da35b7aee34041b8953ac167d59499ac8e227781088"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7659d3a8faa3cfc18132a09cbac7a55e3cb1b3e1901a9593bbce9eced94bd9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6a041df379b31ab8de8b62b9cacf0ce3e72650487424662a34d5a472756688a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
