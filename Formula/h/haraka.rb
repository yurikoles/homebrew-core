class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.1.4.tgz"
  sha256 "798979fb3315ef9c5d70d8ac005768e8a41c34a18e9db8e9254778143a03bab5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b95f881701746e70af7c56fe686598a0e301118b50b3dfe07ba2cf246b3ab73c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haraka --version")

    system bin/"haraka", "--install", testpath/"config"
    assert_path_exists testpath/"config/README"

    output = shell_output("#{bin}/haraka --list")
    assert_match "plugins/auth", output
  end
end
