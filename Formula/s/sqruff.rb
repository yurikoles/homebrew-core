class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "b81730ce3aa4468bc1fbe3d21018545712f57de14e56e2dcf34fd0059a0a2cec"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3237c3ac72d2a37f7a4f48864dffee37e413ea30de4854b20ef6e75d3e7e2448"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "279d87bb03678b1457b96a536c9b4167723ddf9779568893c66c7dd30846ee22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abdfd07b081aec85b7f487a3d48f0dc2763297ecf5196d2209d1a1fec7bdb089"
    sha256 cellar: :any_skip_relocation, sonoma:        "6abb22bffd47fc40af8e1ef95afe25173b605db6a5c1a2c2f4142d3bd7c85ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e98e1323b073d70fb48535e62c01ca6c4740f6cad0f30b22aa78c87a4960d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "653c4763021709e604d5b3a8fefd1f63dfdd9907a0d73c01487a55833ce6b086"
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
