class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-18.0.11.tgz"
  sha256 "6253658b2176efcc66734f19665c31d0c6b8148c3f36d6d72ec15d16871b55a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8156bc7ce65db2d87dfe8d1755fec9ee737a46b7d2b4dc7f813fafc4af358dd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
