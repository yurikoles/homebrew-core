class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.18.0.tgz"
  sha256 "08423346bb46cb33e32911ae2d1aa3d5856c54104720cc595fd96aa726854b96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79f5a35ac35ab28c0b32952257a044159d23d48eb1c9822877579d8e7be0276e"
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
