class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "a3400fd8b460ac82fdaa964b47db5b83b7265b9b42d78ffd90f0e683a8f5826b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e917a5bc19f5deb5b8180dce2eb4b9659a4a4f818295bc5a4d0fc7b0b854613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1527b3bf7e1eac9f73a3299850c4ff6915ce6e28167dd44b127fefe248538d48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd3400f84d0d5864d344753d80a55ec7904c82b4021a92723a287e19cb6bfa3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c73f7fb60b47eafd5a1d5f5ebf0560a2610cfb5ed2b32517677cb6e86f54097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61abaad304e88593df0c8db500ac4a66f2ae7113620ade3c88fa0442ea8b4fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e708d5db85a216d796b6dc8341f4379391b266d1700b7727fd0ce6242485c78"
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
