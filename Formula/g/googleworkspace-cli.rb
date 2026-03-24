class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "bfe44bc17113b798522d74339a276ebf7df049a4c6b56d69bb14527da11fb699"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1e9c9e3eb67771a1c0a8f257f93e7b438c1639f5ff4ac2a17d2515f4aac9dc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c53ba74ad321f5f3ec92c345d5f7393bbcc26697a162d7792618d104f017a36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "215fd8c02d7611ab931a9f5262505a5ac7876345fede6139efdb6f7daf9c9de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2b2e47b697f1d9ad4c649a511085e786ff2c6cb6ccbc1ab3162f28c77e29b18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d36ba1f2f32f11ab6cc280c8172901e63c368abf7ef9a305463fe56b9508dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54df4c4b52b882c170159051694ad8541b9ec42b7dc218f570b9efb7548ebbd"
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
