class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "2ba8b61369c0a6dd370c04ca51f65ad2e8fe2b6a8fcbc82656f30e3be97a6e17"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

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
