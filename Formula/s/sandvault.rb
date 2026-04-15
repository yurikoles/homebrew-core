class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "765290d912213a97ef81aadcdf6dab07dd84634a7b361726bf363bdf5cac2dc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b7d0d0133d691d9c72de1405391471d18c2317be18d30838ea0384ead54ad6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b7d0d0133d691d9c72de1405391471d18c2317be18d30838ea0384ead54ad6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b7d0d0133d691d9c72de1405391471d18c2317be18d30838ea0384ead54ad6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "146309e5327ff8cc5d3ec22fa7e06c09e3e97b378949d56ccf57c79b5bcf5676"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
