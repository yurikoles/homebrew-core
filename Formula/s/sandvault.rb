class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "3ba0d6a55edf58b8e5aac15b4169df3799bed41cb156efdfc16115d5809457f2"
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
