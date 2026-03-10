class GoogleworkspaceCli < Formula
  desc "CLI for Drive, Gmail, Calendar, Sheets, Docs, Chat, Admin, and more"
  homepage "https://developers.google.com/workspace"
  # We cannot install from the npm registry because it installs precompiled binaries
  url "https://github.com/googleworkspace/cli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "45fcf2eedfb94bf8a57f57fc00bdce68e2b83dcdfd593b56efbb8258ae085aac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5653bcec214051935726e0b515fc056e4bf21d1181607dbfffb819050dec5bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13e6922c7a60d7143d10a1998bc7e67d2a7b4114925192ba2fba2b5d290baea3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2e5c66e2d855f950d33ce044714b24625ac979a20f5f9430df1d3d3c3a8914"
    sha256 cellar: :any_skip_relocation, sonoma:        "a516cc858e716e60f8506e2a2516908185cc77b136e2ffc37b49fd3ceb88bc2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "945146f97b969eaf12bc73607a0d0a87123cfcae0717ac55fa62813ebe6ff8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aaa98a2ac53b55118fece3255aaede805fea9043e6f143d5ccb4b30e3c014ac"
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
