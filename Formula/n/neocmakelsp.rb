class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "75f7ff063cdf65d7af76732543c42ec276d3a9a83452b86b2e49407af12c41b2"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "640159be82d4d23a46861cbb80ef16d896afcafd318e25e4d0043973d1b750db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da8ebfebe1f3c801815f6581d61c946793145e5cea064e08cefce2dc412c481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5967c388311aeee5d74ffb1dc041f52ace9aa1d2d781be295575378d1e814d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "657b3a0704c9d64c20e715779bb88bde7a8c7ea872d2952f257457fb240b7650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e99720a859e860d47b76141f3bd6615739af86c11554a96c46ffb8780907ce28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab431e9c480b1d3bf1306b0d04a40c87999151ba35e262979a704f2b734d58a0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cmake").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(TestProject)
    CMAKE

    system bin/"neocmakelsp", "format", testpath/"test.cmake"
    system bin/"neocmakelsp", "tree", testpath/"test.cmake"

    version_output = shell_output("#{bin}/neocmakelsp --version")
    assert_match version.major_minor_patch.to_s, version_output
  end
end
