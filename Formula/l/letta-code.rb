class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.6.tgz"
  sha256 "555a495287e5b401a303fd142ad0e0f3187b6570a7b54cb35864602406f565f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3565c5111691fc4594a0c52588a18340e4b9e61801bb40c8e4d0d4d7bb956d58"
    sha256 cellar: :any,                 arm64_sequoia: "5b8c27500da2a3740b31da8f52053f36e3cf0a1dfee745f3624638f8b7ef950a"
    sha256 cellar: :any,                 arm64_sonoma:  "5b8c27500da2a3740b31da8f52053f36e3cf0a1dfee745f3624638f8b7ef950a"
    sha256 cellar: :any,                 sonoma:        "3d8c3e5d30692a8fb32ce2f0f6d5973982f9e84826343db962017bbc818a4c67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "348da3bda3e9d22157561b338598f8ed3552678b9ec01672ca5f01024b27cb73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a517453e05c93f8cad263727ae19fadea5dd65bafe1c59d8ee3f0f2dab15156"
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
