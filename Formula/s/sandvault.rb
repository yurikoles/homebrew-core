class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.13.tar.gz"
  sha256 "6a323f7409c787e651c5102526a965bbc05865ac96b499e3c6b19d3297454b41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0701fa64b3cb5a70a3020f61b08ea71defc7ab60697af69ebe7dfa9e93a0e94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0701fa64b3cb5a70a3020f61b08ea71defc7ab60697af69ebe7dfa9e93a0e94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0701fa64b3cb5a70a3020f61b08ea71defc7ab60697af69ebe7dfa9e93a0e94"
    sha256 cellar: :any_skip_relocation, sonoma:        "b93ec0e31fbffbd5c74722d24848f4538cb43a3d7202461c678c6f99bcd05c13"
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
