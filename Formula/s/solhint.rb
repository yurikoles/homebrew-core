class Solhint < Formula
  desc "Linter for Solidity code"
  homepage "https://protofire.github.io/solhint/"
  url "https://registry.npmjs.org/solhint/-/solhint-6.0.3.tgz"
  sha256 "7ef8512b176052329ee6f689ca0593510d978422466d752dcc6a76c82de4b681"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbc21f1e81b664c8c06767a4c5c31064b89458f226ba387b6e7dd602de2b40f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    test_config = testpath/".solhint.json"
    test_config.write <<~JSON
      {
        "rules": {
          "no-empty-blocks": "error"
        }
      }
    JSON

    (testpath/"test.sol").write <<~SOLIDITY
      pragma solidity ^0.4.0;
      contract Test {
        function test() {
        }
      }
    SOLIDITY
    assert_match "error  Code contains empty blocks  no-empty-blocks",
      shell_output("#{bin}/solhint --config #{test_config} test.sol 2>&1", 1)
  end
end
