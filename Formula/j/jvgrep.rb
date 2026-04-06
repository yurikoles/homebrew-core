class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/refs/tags/v5.8.15.tar.gz"
  sha256 "8d992c01e39201aa6b513030d2de81a7b17040a6881395189779bb3ab5f36bed"
  license "MIT"
  head "https://github.com/mattn/jvgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7266ca4575b279ba7b16aaae0d2459f16f0c791c4ea1490e11f82f00789d634a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7266ca4575b279ba7b16aaae0d2459f16f0c791c4ea1490e11f82f00789d634a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7266ca4575b279ba7b16aaae0d2459f16f0c791c4ea1490e11f82f00789d634a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9726c8401eaeb5a704be625595d8855fab0d23c0e2a167e9dd0dc315a3cb2c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e072dadb313901731a01dc280102725803ecd42015036228bddfb7608e78b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751113b0e30f280a7237b6322950eb35cb9dcfd01c8a23780ff95fc7d26f3f2a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
