class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.1.tgz"
  sha256 "5e630a377a7e0e643b1c1b16cef26be002d06d33237575684f0c6062ac2dc9da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1e7ad7cd6b525cfa3f140a3d84f512a563a67ba6265da6a2ab6b20a6c6e2b3d"
    sha256 cellar: :any,                 arm64_sequoia: "3afaa55a74632a3f993168f836e93a0268646b41a462bec2d03dc2c4f36e3536"
    sha256 cellar: :any,                 arm64_sonoma:  "3afaa55a74632a3f993168f836e93a0268646b41a462bec2d03dc2c4f36e3536"
    sha256 cellar: :any,                 sonoma:        "72b6bc1d7f6e062d8ea6fba8ba61a57985eab30363d7673d81e092c0a59d5e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12223b226b5c12c8651aafc9ad1e422919dd32bbb41ee3a56fefd04d235ff5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ed4ce5437f144254ab71c90d9ea0f969ace7a2b218ccd36763700db222b618"
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
