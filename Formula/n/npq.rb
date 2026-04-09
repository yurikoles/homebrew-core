class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.19.1.tgz"
  sha256 "99d1d147eed088ae7cafa7005b72f52261755b3ce71cdad0452b0bfbbf92974e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d0570e365f30aaa8b9dd20213c0d9350f43c3ffb55d9468cc8aee5a73e35336f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq@3.5.3 --dry-run", 1)
    assert_match "Package Health - Detected an old package", output
  end
end
