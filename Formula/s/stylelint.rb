class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.5.0.tgz"
  sha256 "8748b845ccefaba4a113dde234a54cc3fbd662d5a07562393d5aa0609375dbb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7e6a628718e1ac8de18d23d6b558ba98d8521797662924fb6533e1c923f44e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
