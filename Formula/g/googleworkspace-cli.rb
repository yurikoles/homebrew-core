class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "a7df48dc7b4d5436ded4d2ef13aa4265ec096376141dc173bceee5e926dd513c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8386b1ec8a39a3074c3d0c8fdf27845ac3dc3c2fd93b1e27bfb6d1c9c4f9a56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dfe0db9e1eeedd4cf8664342f88ad451e13bc5018abf3876e4bceca7f588609"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c6986d5b24933435c11d6bb316ba513d08d55d0c9c7a1f47f18d19f33d9816"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4893c2ecbf99262f58e9d2d358155db302121a34f858f3358e10453576a0581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8f65fc29032885b8ce454f33d581e4aab04aa3f169da6c8c46f9e8cf4f31f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24bfb4eda6bded6d5fad094744872041e05855ff569bbfc8cc8eac2cb49cc29f"
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
