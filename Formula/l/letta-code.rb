class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.10.tgz"
  sha256 "3fc10e27d918b4f25b0ea390e67f7c242ddf46c22c7f4ed899f84f2b44d0cad5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b840cac0908b4a0e3661a4ee73c3d15a32b1144cef56de64e2ffef11354cf9f4"
    sha256 cellar: :any,                 arm64_sequoia: "1fbe07f42a5a6f13974a82785f3b84e2870d0180548b981aef98112ffa6be0f6"
    sha256 cellar: :any,                 arm64_sonoma:  "1fbe07f42a5a6f13974a82785f3b84e2870d0180548b981aef98112ffa6be0f6"
    sha256 cellar: :any,                 sonoma:        "4d8ff5643a0618f42720dbb06594f97f4bd611526c328b57d060d4be707eb261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f631fdbefb90a2b65531037f8f748fb3ff83cba50fce9f8a56b7d9a7c1f16641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a4b0d9f50789a711b2f04624e15703693fc8f3cb5390fc8cceffa09460ff00"
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
