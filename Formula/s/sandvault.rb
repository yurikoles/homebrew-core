class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "655873c20d1a23af461984af8d64f8574728b0d21eae497b8cb2030367fc725a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e69455fbbde4ca9054dcc6f1b97a76df7ef843daba25e7738bd3f5bff0b2891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e69455fbbde4ca9054dcc6f1b97a76df7ef843daba25e7738bd3f5bff0b2891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e69455fbbde4ca9054dcc6f1b97a76df7ef843daba25e7738bd3f5bff0b2891"
    sha256 cellar: :any_skip_relocation, sonoma:        "b28d69fe40d4c1a90e741265b1408075ab8b8666d3fdb2e00726b683b9413abe"
  end

  depends_on :macos

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
