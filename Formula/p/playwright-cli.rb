class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.3.tgz"
  sha256 "28ba2603b4495b71dadea7c6d39636c6d0a2c1414b3ea7d4f91fffd53343e3e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce9410795a92546e6eba8ebc936ef69e0706034f2132185a5c70c497bdcbe5cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5668c6394953831c807a577dce422e3764eb2e09e5deae8d04fd771acc30409c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5668c6394953831c807a577dce422e3764eb2e09e5deae8d04fd771acc30409c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd12d347b22a3d07a22644adaf80db6e9e95cabc639b6c559646035045140c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e972bd5dacf82312eb5cf70db99044da7626427b69d32f431c930729514969d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e972bd5dacf82312eb5cf70db99044da7626427b69d32f431c930729514969d3"
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
