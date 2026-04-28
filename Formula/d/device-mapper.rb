class DeviceMapper < Formula
  desc "Userspace library and tools for logical volume management"
  homepage "https://sourceware.org/dm"
  url "https://sourceware.org/pub/lvm2/releases/LVM2.2.03.40.tgz"
  version "2.03.40"
  sha256 "60c9bb5c0a109f20267bb40ba50c00c84a110fc14c129f21afb5566929bf5645"
  license "LGPL-2.1-only"
  head "https://gitlab.com/lvmteam/lvm2.git", branch: "main"

  livecheck do
    url "https://sourceware.org/pub/lvm2/releases/"
    regex(/href=.*?LVM2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9e1ff31f933f73da3d5b1a2ff37764f7b4ac98d7a5425638f936798c64be7102"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4f287937a1d39b248e7977b1b89bd1a134d8a88426ca1243f081705a7d8273b8"
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
