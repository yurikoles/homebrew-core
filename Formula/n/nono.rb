class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "1bb01bed04219576220bf5c5eee70cb12bbe5d0c4e6610852248f738b1ee9bf1"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c36cd96e7818aeae0236df2c76f13c6af929601dd8bc910f0fe21f3586f9a07e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c54f46d512bf2e2d421a566c570379930dcdf1f2133627faaaf53bf456cbb5e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "433d3b33c30241028e0c218fe4becf8b4b0a3a416dc4a8e004a1fad90c78f4be"
    sha256 cellar: :any_skip_relocation, sonoma:        "23f36dd3a2dc1d422f69424decc3cb6207d06d0d52f2a41025e7afe6b25cd802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f546997d322401494259c3e8fcf9a5a0cfab4b2bd2122be31611cd45314fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acc6ff8c6d583832d4373c28b85ae69b11903ba10da3afdccd42d8513346e6f"
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
