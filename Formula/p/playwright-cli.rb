class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.2.tgz"
  sha256 "ff1c0e12c78981d12e95b10dd8f60246ab4772de8e15a40452b2dfbdc0b60e38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98424477ed3412f638fff0ad9d016183ad1dd298e5fc67924b0b6ef6ec765c55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42482884343e0c2905936a2d6116e3de131378e2d73c225fdd3af974b056dc29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42482884343e0c2905936a2d6116e3de131378e2d73c225fdd3af974b056dc29"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f38242613fe7187bed5aa571e9aff3dfe605236b26382fca12a90085d1b7dee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a06a3bf08b82d485c20577e84f68e603942668aeda6a360474b38c29dadf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a06a3bf08b82d485c20577e84f68e603942668aeda6a360474b38c29dadf86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@playwright/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end
