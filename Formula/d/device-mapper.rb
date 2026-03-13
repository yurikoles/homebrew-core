class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/pub/lvm2/releases/LVM2.2.03.39.tgz"
  version "2.03.39"
  sha256 "54753b7d82a8ffdcc29d9f2c7ff523048a30cc0094048db129496ead1804f482"
  license "LGPL-2.1-only"
  head "https://gitlab.com/lvmteam/lvm2.git", branch: "main"

  livecheck do
    url "https://sourceware.org/pub/lvm2/releases/"
    regex(/href=.*?LVM2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d2aee4bf5e1d751dc34b70f7f66c1e099d7c0de5aa7b11c4c61839d128ba17b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "386ed70dd25c7a97c1a66f46fc9c328c5292988542da6330f3e56aee2771a389"
  end

  depends_on "pkgconf" => :build
  depends_on "libaio"
  depends_on :linux

  def install
    # https://github.com/NixOS/nixpkgs/pull/52597
    ENV.deparallelize
    system "./configure", "--disable-silent-rules", "--enable-pkgconfig", *std_configure_args
    system "make", "device-mapper"
    system "make", "install_device-mapper"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libdevmapper.h>

      int main() {
        if (DM_STATS_REGIONS_ALL != UINT64_MAX)
          exit(1);
      }
    C
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ldevmapper", "test.c", "-o", "test"
    system testpath/"test"
  end
end
