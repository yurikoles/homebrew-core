class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.36.0.tgz"
  sha256 "6ad5100594adfb3a8bfc7cbca860052abb147e3307b0fbdedeede1f71a3f62ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a239d7f397f1dc5b0915271289b7f9da495e4497de148d00f8b5b012a1377010"
    sha256 cellar: :any,                 arm64_sequoia: "cec388f9e6dd655ef157aa330b5339ae5c0951f7c1dbbca5a32be9e07a0859e3"
    sha256 cellar: :any,                 arm64_sonoma:  "cec388f9e6dd655ef157aa330b5339ae5c0951f7c1dbbca5a32be9e07a0859e3"
    sha256 cellar: :any,                 sonoma:        "74b927e43046aa62970b32ae9aaba8e820feb733f13203dfb193c5cca8aaf442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "205e6667458d55d82e917f0f3c92ecdfa4a55cb3a3a6ae0d5ba35cdc15a47e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179b0c9dfa223e5f31c27616a95125ff26f041d631adafece2ff83a5efa5cb58"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url,tree-sitter-bash,node-pty}/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
