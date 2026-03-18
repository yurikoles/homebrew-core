class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.33.0.tar.gz"
  sha256 "6e67c450ba34a0c998d51167e4c1766630a4f0b0d30a41d4afe474076b4522be"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "502abe7ee8bf20e37db452b312cf54240abd03f422d2fd0bceb0c91173cc210f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b99120691d7fcb19763c69e9a204778c0303dfb87e91d1db98beb2b1d44ffbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fea630b7b0a1720a716d9cd2e00ac1e3976fec38b5f39edb305aaceed421eb91"
    sha256 cellar: :any_skip_relocation, sonoma:        "f097630845d83328d96efb241eea4873d85a4a46fd90e469504d3e42abfec6c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5b337343e6a41be487cbd7a4d8d95dd0648bb645c972d5ff976609cdaeb6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d05d29cb246ff8c6f14b9858b428c203b315c5376b44cc006489ae410c4c347"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
