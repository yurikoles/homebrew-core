class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "0f023ef7c353929a17b8038df668329c69e0c8719d13ca6111796d1744bcc100"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23a80b1d8862235c6c82004c82b287ae633721cd44d7ebfae89779dffc476ded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c21e96cb7c547ace7097956327e971ead43ba517be9ef0627e22fde60328a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbeecede1fddf77558134f51ee32672181856b215bb4b5e846f663ec9560c5f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "32c153ab1ed1668c95faa62b081f9bb665595e2406a2cd5b32f0847a3c7cf08b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb87ffe31b7e970d319ecda7c0af019e0baeaef8036ef2eb35a89a7d53647707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4320a60cf682886cdec9e248e26a3e1579671b903f30ebf8d72385c6db1d971c"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
