class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.7.tgz"
  sha256 "a5c3558a18db9a55bb2815cf0506c6e998ec1757e049ed0d2eacd150897a4363"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "004e94f5e2c2dd0e4a58131583ca3e5a9ba7214dea449f22476b8c79f75aba32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38658d97402f79cc0c0c5ee047cf099baba773d8b092eefa5f83f53e72a972a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38658d97402f79cc0c0c5ee047cf099baba773d8b092eefa5f83f53e72a972a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a96e2b663666d27c602162ca50ed89e7e511b951abffd10af4df507aa194b42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1864f736a76513e4dcb664fdd889b3f0b658d995688018d1ac140d22a1f0ff92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1864f736a76513e4dcb664fdd889b3f0b658d995688018d1ac140d22a1f0ff92"
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
