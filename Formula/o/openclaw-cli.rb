class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.7.tgz"
  sha256 "0eb1856cf473eb3f95b50bb20b0c10953203de68fb07e4f7bd23b6b85c3d0b42"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12a35940539fb0ea41bf5f30f48e2ebd9d4656238012f6bebb5d25665bbc9530"
    sha256 cellar: :any,                 arm64_sequoia: "8e3d7c46f7f76514d24561d9d5f07f02d6dae56f3f199f2366024dc3cd39f5f3"
    sha256 cellar: :any,                 arm64_sonoma:  "8e3d7c46f7f76514d24561d9d5f07f02d6dae56f3f199f2366024dc3cd39f5f3"
    sha256 cellar: :any,                 sonoma:        "dfe0de1d22c8e48f16e9eb9cbadaa21615de4fc72fcd905ea5b840fc325e7dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b8dfbb3013db7287dec4e859307bc6a265fe0836246ad376367e7576ea6ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b81f290139435017ab7463dc331a11ffeffa9ada6ebb195ac7a2ee8073566e8f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # Remove x86_64 Linux pre-built binaries on incompatible platforms.
    if !OS.linux? || !Hardware::CPU.intel?
      rm_r libexec/"lib/node_modules/openclaw/dist/extensions/discord/node_modules/@snazzah/davey-linux-x64-gnu"
    end

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    llama_target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"
    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(llama_target) &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    koffi_target = "#{OS.kernel_name.downcase}_#{arch}"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != koffi_target
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end
