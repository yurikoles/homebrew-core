class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "df41954393ea58a917680c0bffdce7c13295c8c90d06ced678fdc3df62195778"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e86e31c6ae03a826867f2745f69182773d6c1ef15cb57d6f28fc7cde3e7b8c97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e86e31c6ae03a826867f2745f69182773d6c1ef15cb57d6f28fc7cde3e7b8c97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e86e31c6ae03a826867f2745f69182773d6c1ef15cb57d6f28fc7cde3e7b8c97"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3adeb1bfa0c8268b9dbe52cbd4774d7c7730fbd58e61ebe7533f883197316ea"
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
