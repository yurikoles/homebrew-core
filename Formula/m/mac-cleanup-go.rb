class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "a67c5b57ff5904ec32257e3e2652dc9783133fa50cf7d63e87d1e68d79fd2fdd"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eb4ec55cf962c57801889d908d663fddde000a2fdbc6e16cb5f8bc34e115214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb4ec55cf962c57801889d908d663fddde000a2fdbc6e16cb5f8bc34e115214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eb4ec55cf962c57801889d908d663fddde000a2fdbc6e16cb5f8bc34e115214"
    sha256 cellar: :any_skip_relocation, sonoma:        "720e8d1797570eaa77d1939d2fbab4db149907bce253f2ea58a6a3e91bf085cf"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"mac-cleanup")
  end

  test do
    # mac-cleanup-go is a TUI application
    assert_match version.to_s, shell_output("#{bin}/mac-cleanup --version")
  end
end
