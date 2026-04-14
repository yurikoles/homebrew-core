class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.82.2.tgz"
  sha256 "03a96188d6f018826a47965c9321f7b8b616435a98a322eba19372821e67f882"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93da9c873814972ac2f683c43b83fc79644f2f90e73f8cc591c0c47552350e45"
    sha256 cellar: :any,                 arm64_sequoia: "929eaf54e1381c5066c2c0f125a7144e3a225ede4f885bc3ca1e0fdb44dfa729"
    sha256 cellar: :any,                 arm64_sonoma:  "929eaf54e1381c5066c2c0f125a7144e3a225ede4f885bc3ca1e0fdb44dfa729"
    sha256 cellar: :any,                 sonoma:        "3efa3f1a6ab01caed913e5da4182c608e369373c3510d5ffbae92293ab27870e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a5515186c883bb57920e172d5c5f4ee589a19eec2a35c47d681158603b9af19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b30fc004cdc62367fffe343ee41217f4e68bf226caed11bc8e7340fb55f3dcaf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
