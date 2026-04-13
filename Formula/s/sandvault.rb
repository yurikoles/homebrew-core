class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f14e091a84d29ca3875e0981388ffa9a9c03e00c8165bad6e1eb2e4281c13300"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7ef81a98993f9a9281ac4534964cde4d90e69d87cac86aa4e38299aa86cde47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7ef81a98993f9a9281ac4534964cde4d90e69d87cac86aa4e38299aa86cde47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ef81a98993f9a9281ac4534964cde4d90e69d87cac86aa4e38299aa86cde47"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8014db6f041d651190e40f088169e146c0f9402f5fdac89392fb58ed0ef52d5"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
