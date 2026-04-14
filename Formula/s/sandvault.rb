class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "e4fa54613467f7e848e8c595f5ed7bf432dfe4f66473455b429f528f97b4570f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5437d0fd9bd3b393d58cf4903af712565caab895d6b3ad79f3b539adbc7ccaf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5437d0fd9bd3b393d58cf4903af712565caab895d6b3ad79f3b539adbc7ccaf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5437d0fd9bd3b393d58cf4903af712565caab895d6b3ad79f3b539adbc7ccaf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "97874a0032e3ea7c298f50ddb7be4ab4431907141ad9662154f93154c4fe298c"
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
