class GeminiCli < Formula
  desc "Interact with Google Gemini AI models from the command-line"
  homepage "https://github.com/google-gemini/gemini-cli"
  url "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-0.40.1.tgz"
  sha256 "893205127c072d3baa2fba419a28081b9fd5cb77c745883139dd9e3e2c1a2b2d"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "5c467a352f626de109e4a5a1f158a1fae4da13df2d91b80fa6a3958a4069fa19"
    sha256                               arm64_sequoia: "e0d38b7fc0bb41fc8ee9eeba6627cb2ebcfa7bf8b75bc5a2cb41322300888a5d"
    sha256                               arm64_sonoma:  "945de33839b513a8ecbdc789f7b98422920314d6a7e50872e4fe814dac224bf0"
    sha256                               sonoma:        "d1d4b2c29a4b91b943281c39cf8d18899a6767aa87875e895f86f84bcebb0f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b6f8a16bda9f5b9431df4df52d09f3202ca5e8433e7cf167655bf2c34ce7386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f827611e2619dce24e86efe7a85dda58174c50255f115a11ddbba5a6a35317"
  end

  depends_on "node"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

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

    cd node_modules/"@github/keytar" do
      rm_r "prebuilds"
      system "npm", "run", "build"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini --version")

    assert_match "Please set an Auth method", shell_output("#{bin}/gemini --prompt Homebrew 2>&1", 41)
  end
end
