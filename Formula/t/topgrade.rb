class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.4.0.tar.gz"
  sha256 "97b325d4e17b1b5699090382af2240c70629432da4677400151aae05af38cf64"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "636f3575b60f63ed090db2f8338bf31e9ce5e9227ac76720c0fbcb9b51dd821b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14544b9b7dd6cdd5a0c6eacaea12f0196d880ba29b39365b43b6f3d3797b44db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43fd6cba104abe158ff1631d099fdf3fb26d637277a022c1b44e30d43d1e20d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc33aaa3d4be3314cb0abeb3733e75b6689c5883c49550128d62a02adc3adbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47a9c2eb13d722ed85149a527343c7e99880075eb6a8a12eb6df0861a3ba7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1dbe5082d8cfb97eb0793af75911e56814d8b6e8da6e5fddf0af0797687ec2d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
