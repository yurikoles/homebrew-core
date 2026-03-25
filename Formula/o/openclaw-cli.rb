class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.24.tgz"
  sha256 "e4079634e040f0f098eb1963360975645a8954c87161c531f0c1d52a2f5f5429"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be8a90d5f2d798aed2fe8146a8a853a6a0c6c2b34186b398f508c9934627d415"
    sha256 cellar: :any,                 arm64_sequoia: "7be934a43cf37e39a96ea254a4d7214b54c59b98a56534b7462e11e29e90c625"
    sha256 cellar: :any,                 arm64_sonoma:  "7be934a43cf37e39a96ea254a4d7214b54c59b98a56534b7462e11e29e90c625"
    sha256 cellar: :any,                 sonoma:        "5544a8a439f09bd4a764cb49e6478b4cdb018affaf55b4e430582ee600a6c5b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "272b1a5ba51b90b09240689ddc91f11652d062e9333aedeaa1e53b2bf2fdd653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3071511540604e105fd2a9a35adf450a1a168880f280b6fca96d424ed00aae6d"
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
      rm libexec/"lib/node_modules/openclaw/dist/assets/matrix-sdk-crypto.linux-x64-gnu-W0MyW8nQ.node"
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
