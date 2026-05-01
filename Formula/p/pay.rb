class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.11.0.tar.gz"
  sha256 "2b15a9e3223e447d3a0727928d006e40c26a520beeb7eed596ac95cbf0fa53b3"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e157cda551351fd224df972bca1463c6198d480419bfa2d2fd3ce7092c9183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba85b84f7b3f72e9be6b9d2aa696f68fb414255dd62411246d118548c36d2cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb65884d06d5abeec1168e342652eb650a4f42c9f2cfe467560060538359c255"
    sha256 cellar: :any_skip_relocation, sonoma:        "0710a75d7c521ead22c7a84fc94a0cbb6f95d9b5c41c4e1c18726fbd75182366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4239ddb75a1b707be592ec854f3306ffc59204acbf9df9ea58e7df89181ade9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f769bba889f410dc14dd1e2d79c69de81fc0ba822db3d2d43c3a8285d88e5491"
  end

  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "python"

  def install
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "no recognized payment protocol"
    assert_match expected, shell_output("#{bin}/pay --output=text fetch https://httpbin.org/status/402 2>&1")
  end
end
