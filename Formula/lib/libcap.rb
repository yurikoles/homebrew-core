class Libcap < Formula
  desc "User-space interfaces to POSIX 1003.1e capabilities"
  homepage "https://sites.google.com/site/fullycapable/"
  url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.78.tar.xz"
  sha256 "0d621e562fd932ccf67b9660fb018e468a683d7b827541df27813228c996bb11"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/"
    regex(/href=.*?libcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6cafec8e7f42270d9bb2c5dac6128cbbf9d0d09095aa3d39d63d23a92ec663c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "564227961f58a88d94ddea146625a6aba87f456f8a66b06e005c0c6f53552956"
  end

  depends_on :linux

  def install
    system "make", "install", "prefix=#{prefix}", "lib=lib", "RAISE_SETFCAP=no"
  end

  test do
    assert_match "usage", shell_output("#{sbin}/getcap 2>&1", 1)
  end
end
