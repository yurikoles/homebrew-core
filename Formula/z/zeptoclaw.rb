class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "70b037f10f36bb615884807dc1b137d91956283b5a2e928850bb35071753b285"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50064b94cd37213efcf71841967c86be5c8f899eef930be7b3634ba4f68b3fec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1ea7ca98eaea2f7da59a2df0a78ce26f03d6682b473316737159ba990629272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2cbb3499a66705737d550379c13bc84173defce35c962a7ba1dd4117cc4067"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7ed6162b59cc703ba01d48b6c25a1905894630eb62110787ee22fbf4265c6a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07967a0b76b687f482596ebce11c5dfd569f32b14dce9d47eb76f47bffc3b834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88329872817e94175b7d23455138f13eef79a80165422de7c875802087d5e035"
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
