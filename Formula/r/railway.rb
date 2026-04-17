class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.40.0.tar.gz"
  sha256 "bd45fbcf522cea65b970c65ec52aa9c2956cffda088da743c6933e13392c09bd"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "020bb12f1938b63a033a6ee8d9f11bd0be48e1657e3fffdaf2000e5854b84cc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "865d1da551df4ff65356b3c9d7100e77142aacef0537c1b82e991f07238826e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8505c54f11bd50513d14b3c1d8e9cb5b3721cba1d42671d846ed80dd58a0a073"
    sha256 cellar: :any_skip_relocation, sonoma:        "238204655cbfad384e53abfbc2b90f56090cfaff53d3a7002b4f500b9f0adb44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41188eda3a725565877a162e9b8798a8d3b7e070693d2049d580d70cbed3d209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e421d06ba19af1df54977deecbc00d89ac88d73a3e70c3a6ca234f271d672846"
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
