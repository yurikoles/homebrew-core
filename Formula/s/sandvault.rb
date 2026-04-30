class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "0892c5fc1dfdbbe2bcdfb0f212089937abe319fbf349e4c49b48fbfb10f84c67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62ec6304ba8d4b77da86c61aeaa3c39d02876cb7aa75a068221f6a436ffe0933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ec6304ba8d4b77da86c61aeaa3c39d02876cb7aa75a068221f6a436ffe0933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ec6304ba8d4b77da86c61aeaa3c39d02876cb7aa75a068221f6a436ffe0933"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af6f388f8624514b93fb173ab4a02202e0016554ace9d9ba434ad5ff50102dd"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv", "sv-clone"
    bin.write_exec_script prefix/"sv", prefix/"sv-clone"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
