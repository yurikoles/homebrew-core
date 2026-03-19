class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.7.1.tgz"
  sha256 "03ee4c0e925758b6946d5d3cb8b0d321f56818b71989b1bfb174c1db1f56b504"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ddd3815d2504ad2df7adf51fbff9f49f31445143c90f761ce31aaea68a495c7"
    sha256 cellar: :any,                 arm64_sequoia: "2238660023449f024000d86716b81db145da1f427559e311d0b4ab3a4d06ec8b"
    sha256 cellar: :any,                 arm64_sonoma:  "2238660023449f024000d86716b81db145da1f427559e311d0b4ab3a4d06ec8b"
    sha256 cellar: :any,                 sonoma:        "8f9434e7c7981ba3e46c87dd2e011971bfe4908bd99137ca8610e140a831724e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7e92df2cc12f7d34eaf75e6c133c34ad9e60b64d7d85da7e11e1c3c81f32bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76e6e22cec5d99cc260b5135bf90b7768ea4e903a46ab30f549da7f16a9efd5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # https://docs.brew.sh/Acceptable-Formulae#we-dont-like-binary-formulae
    app_path = libexec / "lib/node_modules/cline/node_modules/app-path"
    deuniversalize_machos(app_path / "main") if OS.mac?
  end

  test do
    expected = "Not authenticated. Please run 'cline auth' first to configure your API credentials."
    assert_match expected, shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end
