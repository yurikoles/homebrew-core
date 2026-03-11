class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "f0092f3cc76f64a38f925cbf06f09cbb17e14138809cc3ad4117ec4d3c6f82e8"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cf3ba86e6d880625d0f64d8671330dde113f2bc6383bd3329e9b1bcb2b3e158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f932acf5c592c89ecc6ba76273473c2681ca4c95ac492b6f58059f6471a14501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "177d39602f368cab18f666a17ca0dab5db1a53df99bddae84bdfdb918a844d04"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb4948f1d60636be305dc90aefe7b6c8d1a42868b66da328609e4229acf0f610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5062b9b63dec235eba0f8eb8a790e39ba3a886744d3f0a30bb4268f5fad40f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd52fdbb15e1f72ff1a4231b40377354c0edcc12cae3c952c178f5f97f2efa1"
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
