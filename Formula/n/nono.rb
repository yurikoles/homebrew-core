class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "d454ef7329dd79fc1984831c32f6bdc31c51d2468e12f575a6ea44e57ae6de1c"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55af83b42dda422e9e04fda7ba0639691ffa1e663c3955b5d85689a46e5233e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcc5073c61eeb026bf906af6253f3c48ccb2aa1902fdfe5669e2009d113bb57a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dada6d7816a0c8a6bcfffc483efa7963c2d60684ef4933f0e5f622f6c5b3739a"
    sha256 cellar: :any_skip_relocation, sonoma:        "41fba64deddb76b3a33df13ea5be4c93d30f9de21f61e57520e516c40ac22716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970bc02a48441c8e66d8342531f5e32846d29fedb343797d816e2ca9d82fade2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5226fb0e18701ba96462df21a9025cf445a3701a6c02ed11f5d3bae2f6d217dc"
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
