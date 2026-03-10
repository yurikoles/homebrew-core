class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "7039c3c5b533b43a6650b66ce9c76c850524455b8d8d4a2f5a7d98f8318c8b1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1602345a2486f80601289fb1397d6a54dc83c1acf7e28a1accb31a25cc8f325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77d13e0d9258070c5666c5a9f0ca4155ac73406ee23044f65f3c1b5c77d7a1b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c48c8eac06a3eda8ecf35fc6f6f72c049dc4f7bc66c73ae6ef3fc8695a6a38d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "09b7de4bf546a38cac11a24f434c8780c1898ebecc77216e6637cce1bb438d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a247084751360c5bb905de5aad94391be9d70a53756a27e311d0bfda36615a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82fbc67159268d44d8061980863b86734aa0b1ac0279ff1a92b71e28745d07fc"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 1)
    assert_match "Access denied. No credentials provided.", output
  end
end
