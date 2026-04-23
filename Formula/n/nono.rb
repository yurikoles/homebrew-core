class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "7dcfb9eefe619fa29fed76213b3e5e11878e16ec6bd6994b4912ff904c2dee8d"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5eb60218aaa0f0aabdc4c8e6a6576fc361a1d5ce873e3c1859b36f4ad5d57cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c1f6be868f10fa9402ae5ce0a9838fff3cc7ed557631a06ca3318d405898740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55538e9820e13b3e128dd3a48ae2aa00f0e39b0fd91f78c1688c6f42321304f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a38376ac7734dd88cdd61fe7e6a9f325025496ecb827f33d57ef9ee0978bb17f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e52bd769d96a9aa1f16b8dc0375ba4a6a189428c7d55bd332da213042dc7412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7742e39980a63d5169d791651fa6a14e57a681ed8558c543d63c572857a8c077"
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
