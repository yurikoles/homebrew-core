class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "6dc5980c361208707777ae01ad43b954da8149829ebaf03f2456629a8ced68c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "324dab762b3877be46de0e82b01eefa5409a5eeccfea2aff26cb5f9ef614f8c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b9c269fdc2080995c1172c99f992c984ecc75d2aff010a6a5375a2062e4f4e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0921b1305ced2ce15187d0a9ef790be6b69eda707ee402b7da1620170b77fcea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1e0e7b30ea42b845d300b9ce3b4ea706f26926e8a424a56325245f14b74091c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9332faf0a78c9cf41069cbe690c66344209fffd263ee236324419e9ca4f6f47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a522655cb838f5e91cd602440f3c650cd2f225aed2ef58b59c65e4cc8ab6b38"
  end

  depends_on "rust" => :build

  conflicts_with "gws", because: "both install a `gws` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/google-workspace-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gws --version")
    output = shell_output("#{bin}/gws drive files list --params '{\"pageSize\": 10}'", 2)
    assert_match "Access denied. No credentials provided.", output
  end
end
