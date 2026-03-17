class Sqruff < Formula
  desc "Fast SQL formatter/linter"
  homepage "https://github.com/quarylabs/sqruff"
  url "https://github.com/quarylabs/sqruff/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "16be8a8f65ecd6ee9af10884b69b07683a41abd715df5946e571af1b1788248f"
  license "Apache-2.0"
  head "https://github.com/quarylabs/sqruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ade79660223eed2340d1231c89d1e44b52ec63e862283fea9c72f678f7d795a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe29f9233af19adb1a54cc7928b9318cd140f9ba0fdc01ff2ec26f03617a86c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f29d19d13b986285fd87950452460f2371ea083c73883959e8e17aa5d40dee0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0665c68962bf1131b557ea2c131a84b1f34de13a0944d08c757544b935f68810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13200cd3d085164cb96c005e8bf3a8f2c32fe7ca4ad5c3a10acccbc12fb0adf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca172b591034ca84f5b39a01444163ada9800007942ab1018e12761518ba6499"
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
