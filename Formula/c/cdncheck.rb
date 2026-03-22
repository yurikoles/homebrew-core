class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.28.tar.gz"
  sha256 "476cb9bd70dbcb445f75d85b5c2ac5393e5fc0c1ad5a858bdfd6706f40fb4685"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03a993066319bf9a4e79f27cba258645bd5b9f57a231507d40abc926929d2839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44b19c2bf078f3b30d1793cfd6eaccda87514eb619abfbd2932269f41709c36e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7436ccf5262b9b5353da62e9e7225d060bc960415391cb0e640eb25ccb7c94a"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ca494c39fc7854229f67f8b15fd0ad09ffddec63d9d0ec2b1d61fed60a75a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e90a7d015aaad4b2867ea0c707bcbe66251dbbfe624545652f01aec37e3baa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f096a9f7aafb6ff3804ca473e9027df072ee8e82618879308c6b1bfd728841af"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
