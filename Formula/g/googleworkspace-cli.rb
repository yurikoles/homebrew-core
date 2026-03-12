class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "1807b2630d3f5876e3161e377c97c1f111a82d4923609ecb05a56820238c95df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbeff4d6aa8b3dcab8055a45d9d1240c8dd73119d8bee2a6e44af22acd33d92b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fc5c408375319223227c0335e50866990384536aaf1941dc4900aecdae922ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6583f66a3d1c4b5709deecd9ee5e07e91e770673d0df4ea27ab8db9f4d87b24b"
    sha256 cellar: :any_skip_relocation, sonoma:        "41b3ede75962a6cff732e9ca3408b84406dbf90b115f9f87a12ff0ee37a655fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29dbb63abc896279afc0c369ab5b94becb18f15d6d77e6141a12c6e0803e4bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601c7f8e9228d21c23bd2acbd575f2a1ac5a2b1015dbba931dce947f63222c92"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end
