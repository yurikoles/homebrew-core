class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.42.0.tar.gz"
  sha256 "890066fe73a471084a9f0f83366aa88c76391ec8f3a2259979dfa50586a26f2c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47cc962bbe9fdfa2db68e588702e974083ac40fbc6316225270b77c0f82cc6e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81486de04ab4277fcc804dc30b956bb308ac0306e0f10b18bef3ab20922e32eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f94136537ab6e3c347bfee82c9d1570913f3eb1f812471e68f5f26f3b97e31a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbcdf2e31ec9daf714c961422047bc3806684e8865c4cb04d466fbdee11b07d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb4a581468d59dd9dc62ba09e45b7b6dc40cad2b05222c00a2da482befa84fb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab3bcd0f8469e1119feea675881372c836b1a086e67ee0576ce2f819366924ff"
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
