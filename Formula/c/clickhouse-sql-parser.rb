class ClickhouseSqlParser < Formula
  desc "Writing clickhouse sql parser in pure Go"
  homepage "https://github.com/AfterShip/clickhouse-sql-parser"
  url "https://github.com/AfterShip/clickhouse-sql-parser/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "dd07759984410a40cc7ad5b78a6d77af66f1792f417b053adf7c47346523ba21"
  license "MIT"
  head "https://github.com/AfterShip/clickhouse-sql-parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97a2c673b71be12498d1733e7edd83f2cf0a72a295f4e8a5fba6df4eae5ae444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97a2c673b71be12498d1733e7edd83f2cf0a72a295f4e8a5fba6df4eae5ae444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97a2c673b71be12498d1733e7edd83f2cf0a72a295f4e8a5fba6df4eae5ae444"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaf74e1e589c86d28d4b08cf2c3257b46e19385cf725eb525c4d26e102de43a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b29658b9024565d8ad4fc99fd3e8f68cea48b375aa91935e3cea37b8180e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc5ef8e356c918c6a571377388ccc45ed6248e923f839f5da576bea4602c53c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/clickhouse-sql-parser -format \"SELECT 1\"")
    assert_match "SELECT 1", output
  end
end
