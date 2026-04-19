class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/-/archive/debian/0.14.4/posh-debian-0.14.4.tar.bz2"
  sha256 "3049d0720976e5920e46e0b0e21c139121d469ed46616caa82dd9e892cb8f195"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{^debian/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70ed90a9ba1af8332eec0cd641be99cfee45ebfc60e73c10554200a7684ff6d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "207821a903ce20aacb0f05804f7e24b9b837e6db67ab09e7588f089970e8c7eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "002e2fa0c7772793365faccfc8b0f16f451a9255773617cf22a6cf6728150957"
    sha256 cellar: :any_skip_relocation, sonoma:        "1033d4ffcb76c7f504e9496f3fd29e45107c7f820a6306036ee16bed4315bec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28a5b8385f50861d7269e8ac365a8dabe55c1e53e2da2fdbd0afac6d66d8863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f75a0f89d5f9043a9d0f93c60a1ea72fcb59a2472461313f922ff31c3435cae"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Upstream still uses K&R function definitions, which do not compile as C23.
    ENV["ac_cv_prog_cc_c23"] = "no"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
