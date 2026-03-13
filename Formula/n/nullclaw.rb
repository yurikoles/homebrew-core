class Nullclaw < Formula
  desc "Tiny autonomous AI assistant infrastructure written in Zig"
  homepage "https://nullclaw.io"
  url "https://github.com/nullclaw/nullclaw/archive/refs/tags/v2026.3.12.tar.gz"
  sha256 "b5e853f254f1b1a8af6a8d622e03bd9e0b450875631da25c151ce1ea1651d652"
  license "MIT"
  head "https://github.com/nullclaw/nullclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47d75895858f044885fdadf1105b66aa785013db3b26a930401d1d0420cfb366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "958b43fb25f0fb082b35f6b1ffff9d282dab89433323f7415c243fe4be9123a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af211883ed0f5a29af47257549fc1a67cb72ae445ae4efc580ec1f7eea1aeb5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e07e85124bd5d05f0f7f7fb4a5198746a4b03bc36e01cffcdc69c72193b71af4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2978d08b95b49b17c71018588a1e8de2f4b18823bfadfedf74d2607f30a73f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef52830e9fbf251c74e90f8b11918d7b2ea37e01ff4866aaa6415f7b220f328"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = ["-Dversion=#{version}"]
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args, *std_zig_args
  end

  service do
    run [opt_bin/"nullclaw", "daemon"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nullclaw --version")

    output = shell_output("#{bin}/nullclaw status 2>&1")
    assert_match "nullclaw Status", output
  end
end
