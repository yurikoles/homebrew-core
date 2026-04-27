class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.19.2.tgz"
  sha256 "7eb3adc552c4222116bad3dd7b26d61dacf451125d0b93c62b7123b884216b94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a26516567bf30be84b45d5c03f33476ca51a4cd028c837c1cda15c2c1a6f6036"
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
