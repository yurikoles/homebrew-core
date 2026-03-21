class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "e48ec3d15d74994da67ad4d41dbeb3654ef9e10241c0de621e3a20a5bb9651df"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ce6ff93e56a7b6628ee086ded9d6a67973526a195e93c9a40c8983f48e549ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad845f2fc3074819ed05f7832a88d88d371f59d1fcd1648591f99afdc7724aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9d1060f7fd5a5763fdcfa27b80cec1b01e9ae5b44c007a2e4123b496f9138a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ed9136c557772dc74de44ad54d9896e9446f34a7ea901a2eaac8887abfb1f61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f15d93af27fbee4a4eb947d4673a7e4e975d77afe12352ed22932b45c0e468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7c4b588038acfa00b186413af3982dba4f1839dd033650b699d201b9fb5d0b"
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
