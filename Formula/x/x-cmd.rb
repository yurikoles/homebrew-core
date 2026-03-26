class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.11.tar.gz"
  sha256 "e8873f8cac34c35466a077cf55691b8e50dd95a6b02b05b8920dae3edb791e85"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "297bd1af171c01fe19d253a03514b2c8a33d7a985883320debe0c86eadfdff26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297bd1af171c01fe19d253a03514b2c8a33d7a985883320debe0c86eadfdff26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297bd1af171c01fe19d253a03514b2c8a33d7a985883320debe0c86eadfdff26"
    sha256 cellar: :any_skip_relocation, sonoma:        "7734bd602cef9e81b8cf0b0929c4a1aa6021e3fefcb7c2a03c2ae68b6bed1d6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fee252cf74c5ee95f73ad240ee32e4952b2a7dda1f58e3be6288d59a29ba9924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fee252cf74c5ee95f73ad240ee32e4952b2a7dda1f58e3be6288d59a29ba9924"
  end

  conflicts_with "xorg-server", "x-cli", because: "both provide an `x` binary"

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
