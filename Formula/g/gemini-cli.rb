class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.25.0.tgz"
  sha256 "b1afba002edf8d8de3f36a4df2772716ca8001fc806cb7570f6c61d4b034b3f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e3dc6c8c9306224c4d67df860c6ea286065a62b480173e8b2b68874df4ae42c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e3dc6c8c9306224c4d67df860c6ea286065a62b480173e8b2b68874df4ae42c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e3dc6c8c9306224c4d67df860c6ea286065a62b480173e8b2b68874df4ae42c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c44577eead87399acaa41bf337762ee4276d516d673589686c1ec01d3bcf867f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "865174e701a763586d3978325e72502750da72cb5867faa1741817ceae461899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19646f194535ab10db458314837bd854ac9521e06f4addf454aea420f5e00d4b"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@google/gemini-cli/node_modules"
    (node_modules/"tree-sitter-bash/prebuilds").glob("*")
                                               .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    (node_modules/"node-pty/prebuilds").glob("*")
                                       .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/@google/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
