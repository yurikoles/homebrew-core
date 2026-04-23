class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.0.tgz"
  sha256 "5f87f0e8730524303fa855ed4bd9fb96092d594b2eb4a36cdf2e53ef18884ca3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfdb1185770b116b4915e8365a0769629984ef05d74fc864de74feea807345d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfdb1185770b116b4915e8365a0769629984ef05d74fc864de74feea807345d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfdb1185770b116b4915e8365a0769629984ef05d74fc864de74feea807345d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfdb1185770b116b4915e8365a0769629984ef05d74fc864de74feea807345d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfdb1185770b116b4915e8365a0769629984ef05d74fc864de74feea807345d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038db71da32617a0851b68acb73576a38a1edec88f41d36d9261c592ac5aaf56"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
