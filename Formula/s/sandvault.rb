class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.10.tar.gz"
  sha256 "3cfd648441e80305403b9696eb8c79d0fa9c0ee40fb1b0c0b96f2b0138537077"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "118accd0fa5ca49e0ad397914cbc697ec187529db4ff6d860a9a30cdeb8f9eb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118accd0fa5ca49e0ad397914cbc697ec187529db4ff6d860a9a30cdeb8f9eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118accd0fa5ca49e0ad397914cbc697ec187529db4ff6d860a9a30cdeb8f9eb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d3790b5fc130bc34218b523973ef44bc7af5bdde19f96daadd504f322bef95"
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
