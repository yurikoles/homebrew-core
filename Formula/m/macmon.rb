class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ee99781d0f1a58d21e802acaa7f5850a8a43935c86e71158dcbd07b30ffcd941"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "707ca07e18e491427e8228ff6df5b5c880a9ca13f11cbcabfa20517bb4038912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40c85d57a50a820f9bce74cc027391722b92db792c96103d08e3be6bd5f3f066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fa72082accd0a061484259af4d817129ced58675f02a9d6bcf580aeb5d347cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e22dab57f3054c606a653676b0f0c8f09675a504f0c707814b08668cb0036c6"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to get channels", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end
