class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "3c035dde8433495dfa36ef968b2c3c84f5aa5b4f546d80b933137eba7c496810"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b8625bbc26585de60eed8f19e9ab7e27fc9b8532cf01dc9fc5a016cba03c925"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b8625bbc26585de60eed8f19e9ab7e27fc9b8532cf01dc9fc5a016cba03c925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b8625bbc26585de60eed8f19e9ab7e27fc9b8532cf01dc9fc5a016cba03c925"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde7d2f7fd556af8b6b810f0938d5fd4933943de3c92c245eb131c8c5d74ed3f"
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
