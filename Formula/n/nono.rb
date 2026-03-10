class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9f3673b540c3290b336366439b70c776d1b04635342a6c9ccfcd2f0a1bb0d42e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "006a1cfcfcc073ce8850019e2d1f55b402768e68b0112dd155fb5551b99f7922"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7010340b6ef99a0559d57575542d672a33589fa8f1ccba4b999ca49c12ec4544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d7e1ee5561562a5d6704c8558eec8e9eac2cdbfaa34ded43f537a37443d91e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f729825f7dc985371baa87a2dd13c6fd95899516b1f53e0694b2d6eacdc75076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce60d8208fd05816c2be4feaf40c5b42a5523c27565152cb90cfd79d90f75ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d27a5060290739e0271ad9cabad16f3de8913b171d29b3dca5a930bfd5572313"
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
