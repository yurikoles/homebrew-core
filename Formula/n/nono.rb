class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "8f7c8920b6578e57f7f61cf8c733883fddf87e8e479107d8ddf17390ea624bec"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20c5dd711711ab3368e1ff9a142fc9ca7be9fdf1530eba739e299300c996c149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5a10cf38eb1fba616e069750c942843d1021d214debb1e7c2b3d0c45b056d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "886ef12a30f98e0e0e0b9b9abc08ece5d443a97846c701b9606c71a0191bc026"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcfc4fa3efef6c75b47edde1d27090370dc3454365c15bcb5e78448c08a64185"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45659892a1a6169f2528c5f0a118bb69dff25e1342e340951d05b91ef1b3e575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c46b34f2922145331d18d026ee9f6a353a12edec51ed10f15025c01e84ff243"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
