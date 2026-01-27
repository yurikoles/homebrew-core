class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.1.91.tar.gz"
  sha256 "088b9f6a9507a58690e5b35ff36d0809e6a84efb62dc2bf2c9e10171a3ef3c19"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f6b47ff3de7ba2574635a52611c7f69a29231be2ba74037c68390f552a7c60a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21b7f04e344656a7cc62db4289789c28c5332963888e2dba04fc260eae8d9d65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54abf2f4595d5f2b0576dadfb0364439af19d4e29532374aaae68640f1740bcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9234447ce402327936d4f1ceabaf805e182bd460f4bd0296ec9ab95fbc53923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62fd866a838857522d50c556b425ca830bca1eee6cff5ab5dd2aa283c607d370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d102b8917304c3860ea41bce075d6e428ca4c32a786cfc01324ab71c336cef1e"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
