class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.22.5.tar.gz"
  sha256 "1e55ec8c6ee87fac7d422975604a2d546c35f6d687a1cfaba7c7cc0d3c05663f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee52c728c35d71eca6cc1feda3d62338a6a4424fc09ddb5ed9ce7a15fa388209"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e3058a541a974c968391570c2909f9a87990d6e34df5c8267af466ee6029807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45908ea8bfee1067cb876f7ca0c122f6359460c447fad0c970c3a8424c724af"
    sha256 cellar: :any_skip_relocation, sonoma:        "e848ded2afe0db13418e5aa540e002aa72fd51b6fe9e9947eeed914eeeb828b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db510387dcf29b53408874f4105a9af60f66bdbf496cce8429b0ee3dadc96920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d918d0e9622435564836544093e78177c73c98c7c3b3222d5b56dd0f45d42ea9"
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
