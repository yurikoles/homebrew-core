class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.280.0.tar.gz"
  sha256 "16e85050dc0c3da1853245cb9f00c46bdba4fc3275ee0edfb3f260b05b399a0f"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87632dbe27db8eadfcd91778bef9a33fc64fee01a278f88a5d26a40ac3ff8172"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8cafb650da0ca5cc96a21e4191ded3156c1a0a9b60c695ace909083ea50a575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91577dfc7d1c1e96215852713a47cf63bb782161624d1a783479591cb1a9a798"
    sha256 cellar: :any_skip_relocation, sonoma:        "663a55f87dfa897e5c1f14884a1c696357d3035c65a284d582921fa7b434596d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c5efccc4540671124f022b23d83e515fe10637d2afb40e9dd7daef41473eac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b67e5cf48e20f322d19a555ded0b656880f812c87f1362e4a4955491feb79b4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
