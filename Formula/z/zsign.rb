class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3ea97b5ff96b5e115757dfca969378c38682507282d30e2a4583b2a2264e65e7"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "112e9f1c1851a57abcb9a4c3572ca541d2fd1e7f28bab4c4cf03a3675270be0f"
    sha256 cellar: :any,                 arm64_sequoia: "2ae35eb0a2073bd49e72ac8197f5f6764c60819fad02df3a712555a79e69383b"
    sha256 cellar: :any,                 arm64_sonoma:  "c7948d6857d1afa799860c9ce513ca4fb849c0185222e52faebde6d187bada24"
    sha256 cellar: :any,                 sonoma:        "e59101bf3c97ef4dd0fa1817a27ecaa9542ea8eb40649be69b4be759cf9c5edb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66b0c9743c317c1c4db84fa334ef2ea1f65604f5348e8553f7de6393c620f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d18ec9061115a4c0a0211628b3d8b256a67ea8140615cc2ed1c5c4238b57542"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip-ng"
  depends_on "openssl@3"

  # Use minizip-ng in Linux Makefile, upstream PR: https://github.com/zhlynn/zsign/pull/386
  patch do
    url "https://github.com/zhlynn/zsign/commit/d4c32a6c877a62cf4b0b39dcefcd37e898f940b8.patch?full_index=1"
    sha256 "0d7e25f328016f2b5d21f67db07d300a0ff928a1d9aba213e8b9336b10013905"
  end

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    system "make", "-C", build_dir, "CXX=#{ENV.cxx}"
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end
