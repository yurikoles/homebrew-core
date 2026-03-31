class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.31.tar.gz"
  sha256 "73ea8dd5dd132023fc7253ed5b86d66ef53eced53da80e89287db4c3fa89e081"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d0ecb7f7ebac0b720b725d3f6d8e648e8093432159e76fb2a66862aed866b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0ecb7f7ebac0b720b725d3f6d8e648e8093432159e76fb2a66862aed866b89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0ecb7f7ebac0b720b725d3f6d8e648e8093432159e76fb2a66862aed866b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "c74358e195f42f791c6ef6496959042396167054f09aa5a39dae44970e96d917"
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
