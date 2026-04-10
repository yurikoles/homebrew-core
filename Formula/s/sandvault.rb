class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.34.tar.gz"
  sha256 "952eb0d27f815445ac744d595b2e81d468e5af3b21b1355a72f65326a249abfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "220c0e9cf5cab309da6a4ed0f00e4120b7b800cfe08e9d58a20ba0bec0582921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220c0e9cf5cab309da6a4ed0f00e4120b7b800cfe08e9d58a20ba0bec0582921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "220c0e9cf5cab309da6a4ed0f00e4120b7b800cfe08e9d58a20ba0bec0582921"
    sha256 cellar: :any_skip_relocation, sonoma:        "75fea7be6ccc75eabf0465a0a97b105f8149827edb6e07ff6768d457b9ba5bec"
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
