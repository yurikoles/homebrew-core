class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.32.tar.gz"
  sha256 "dd2993fd9174382abff53a71c18aa6e991a2e9bb83b6c49ff0d53af6624bd18f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61502d427def9febd90b82fc2dd8bfbddca804ae15c84ba2d10ec29940d0e47d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61502d427def9febd90b82fc2dd8bfbddca804ae15c84ba2d10ec29940d0e47d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61502d427def9febd90b82fc2dd8bfbddca804ae15c84ba2d10ec29940d0e47d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9629fd0ae7e8b8e09ac844313e0c102863ab707338766d1330799bfe148e6dd1"
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
