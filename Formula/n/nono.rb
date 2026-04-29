class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "c4a3ab52faff4405a099e39593226d857dcb796db65f983a97d65ec8bd535cfa"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53523d5bbe3be9d1cf94b0b3d09b4e56df512cf9564b3dd49370416eecb26f9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a1312d203f912342d9a9eeef57bfb546828f05faf7a383f0da97196f229c680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5c65949ac1a0f41fc2f12cb42aa77aa64afa0b0095646f97de60afef126074b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2afff1941429f012049f11b4288a14d459433f05a3a88ab4061982bf50d6237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55afc25d90e8ace72944f54b1e72f127a09c4470c7b4879dc21b486d40211d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98bdbde1e908a957f5b213a786324c34c42ef70d319ba58f983f4ff94b8808a"
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
