class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "1dcd5315d6209a403d7bacdc6062d2bcc1c418990c4793bf1094d46d3cf38c77"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ca6a0c71c37b43c68c4cc36aee7e5f2daf59c709aafbb1b78934e5cc50e0608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "181b2c40975339fb614cec72c0ebdb237cc35c656cfde6aa58c1c3ab39ef5b7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6291de7b9eaa435f2ae18c37c6f68bbbdaf74424976f8a4e67ebc27c17e802"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a4a80db837bf73ff90f5e839102f1022fddc4747520ba7db9f7dfa817372af7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8655a7b91427f9875b53398a8bdabe20fee3ccc20b14bd0612e8abf4ad5b810c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d41747a8e094fde984dc2efe195e4cc742c6e4e27e0fba4c9d4b45f31fff095"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--bin", "sqruff", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqruff --version")

    assert_match "AL01:	[aliasing.table]", shell_output("#{bin}/sqruff rules")

    (testpath/"test.sql").write <<~EOS
      SELECT * FROM user JOIN order ON user.id = order.user_id;
    EOS

    output = shell_output("#{bin}/sqruff lint --format human #{testpath}/test.sql 2>&1")
    assert_match "All Finished", output
  end
end
