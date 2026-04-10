class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "c2453fd036bdd1f4af6ff4882768ad1b23cdd95d2eb4c0d4f68ce0512b794b70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1a0f67c35d69210b11bb62b101f4b609e8f1eccd7037d501f5bb9ff75fa0c40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1a0f67c35d69210b11bb62b101f4b609e8f1eccd7037d501f5bb9ff75fa0c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1a0f67c35d69210b11bb62b101f4b609e8f1eccd7037d501f5bb9ff75fa0c40"
    sha256 cellar: :any_skip_relocation, sonoma:        "75b77dc3dd23a5feb79632c48619f070c2e2a2f89765d94b9b4ee7cad535cb8a"
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
