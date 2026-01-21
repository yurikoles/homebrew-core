class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "b30039e5a8a3f0c01e5c000ba58d8027c762564a6ddc27a247f2a48e59828e06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c058af8aba8e24e4697be6922f7b4a70380d2e5c45fa83a040968f0831014102"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c058af8aba8e24e4697be6922f7b4a70380d2e5c45fa83a040968f0831014102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c058af8aba8e24e4697be6922f7b4a70380d2e5c45fa83a040968f0831014102"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f2748f7ec0958d41a7b1ec1d9d32a3094169b32085fc74c7ac97d2cf28f5bec"
  end

  depends_on :macos

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
