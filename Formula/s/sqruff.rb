class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "c03c9bce72cb4ebcbed2ef5f3ef64f56ed2bd7ee7a75db623a21a60e56043f37"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6983202fec762a3ef9f8985be1ffd12b4971f3a84a98a5239a5b5c641a002627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487c36a0834f8a574cfa07720c9b6ce5fe904f7d63e5d6f1d126c623cb93c7b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521c7971a2b4dc575bd97212e71d17c7d1f6078dab375e9fe76690318b92ae52"
    sha256 cellar: :any_skip_relocation, sonoma:        "71bdd150183026c13a6c80e126030a64fdf44e0cc8283bfd98bb768f7a1e572c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afe28947e997e652f5983a80f9e603f209de266d1d4ba28e49f69bf0b9ba5b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d0d9ff70fecd6e21530e549473d59ab9f20b794ac0803ce8af2bdd037d3922"
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
