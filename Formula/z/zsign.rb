class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5268e946c654bdc3ece16905ea93f2b961c1235adc07127553a8b335d17ee393"
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
  depends_on "minizip"
  depends_on "openssl@3"

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    # Makefile hardcodes CXX=g++
    args = ["-C", build_dir, "CXX=#{ENV.cxx}"]

    if OS.linux?
      # zsign messes up the zip include path on Linux
      args << "CXXFLAGS=-std=c++11 -O3 -Wno-unused-result -I#{Formula["minizip"].opt_include}/minizip"
    end

    system "make", *args
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end
