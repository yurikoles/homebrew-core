class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.2.1.tar.gz"
  sha256 "f8a0868885a75b3591ab7d77f2e1d7d9a0178331ae058f613dac219bf47e03e6"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bdf2245a575cc091f91ef09db42321f01c80a8d68ed0b514a3135753e505e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adf5f0ce842c1f7aebd9bca15c9b4a93533a1b957e408667e6fa995fec481e58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a30abb8a3152fb9a0becf5a2f641416b79ac932c113973dfa2d6f904aebd5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e7d949dcdbc2b0d25b6ef72254bea0e9e35a112c3c9b5e5a42bf350721b75c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "524134e8a6dbb31152150fc8897ffe0f438651ad2d7050d91e6383b5b10ceafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2992fdd104cef2de657ae779a50fe2854defb9b030307f30a5f7ba918a345848"
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
