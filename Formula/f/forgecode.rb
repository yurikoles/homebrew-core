class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "e1acc8c8dfe707dcf00e90fc814c06545076e8e0c68f15399bf1ea4807c38497"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfc5d51e1c4c3b6b08a4937209b368d49824f2a8002098950403ba64080f6482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01ae6569c96bce2c98372bf97ccd2565a29a21a36f5a73b84169b29c950efd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4f0e8dd3c61c30a3c76801c08ca539c719b096304ef083ece545e9cd44a1548"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d618ec7dbae1ed178a710a78e4c329012ba46e755d0a1d4456cb852eb4e9ec7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "341936912dfb17cd6bac3efed89ea53ba02b59569acf7da0455d9f35a9384467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8eec2828f4c6398f7d58ee06236c6490421f753df26a27a0252ad461ea958c"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
