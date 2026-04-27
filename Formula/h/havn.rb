class Havn < Formula
  desc "Fast configurable port scanner with reasonable defaults"
  homepage "https://github.com/mrjackwills/havn"
  url "https://github.com/mrjackwills/havn/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "a9633b2e509591bff8fb0ac36e0e04600a74ad98c0cdcb4a9c5bff48751fe51c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3611c994025cfa25bc0dff6b08569366263e247305f71c2af4f76afce8514e69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2bfda5448e5656a4143793b8d048b1d61bab51a72564317b170362eb36acbdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd75e60c3112ce4fe72e90293da96f155254351de3ab3437ac5961f5e13b7d6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c49ca29bc22a165b7bd2167f874bb7e41dd2ccd08ce5dfac10205d4185cb27f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c9383585f4ad1f8515757c5f0402d2db9fe7bd806f74d262ea7bc5cc590b799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea4808219963ad595b2d56335e6dfc1fb8b0380f00992acdf68a02f49bc5cca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/havn example.com -p 443 -r 6")
    assert_match "1 open\e[0m, \e[31m0 closed", output

    assert_match version.to_s, shell_output("#{bin}/havn --version")
  end
end
