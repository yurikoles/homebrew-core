class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.97/ortp-5.4.97.tar.bz2"
  sha256 "83065319fe134a247aa7969b23bcf999728abad45fc7278ebd4df5f237ef9331"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a99bfb73fd837b777c62164a9bc0d5acd32b72cbd72eb9fdaabde2f653ed8ec8"
    sha256 cellar: :any,                 arm64_sequoia: "e34c56713f1f56aede833340dc53b07ce753f32ddd152e746cdaec5ecc326c22"
    sha256 cellar: :any,                 arm64_sonoma:  "f17dbde6761a15a072ca3a3be0837da995ea3b2ef7d97a442a6a283ff540a2af"
    sha256 cellar: :any,                 sonoma:        "ac80a411f3b9541bfea005a56c55d610a0ac843b0bc2749054ed78fb5580e2fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b349f698d3bee8565938f43f8651f4bf05116c8489a47135b12c7ed6a385113f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4229324bca1614ee5f4d509601d698f0b2c9a9a33e2587a5fff4baf7f3b9e8b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.97/bctoolbox-5.4.97.tar.bz2"
    sha256 "ba47994636696ad3533264f1f286c13617b3a8d33c8edf236e27464e2f8e5742"

    livecheck do
      formula :parent
    end
  end

  def install
    if build.stable?
      odie "bctoolbox resource needs to be updated" if version != resource("bctoolbox").version
      (buildpath/"bctoolbox").install resource("bctoolbox")
    else
      rm_r("external")
    end

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_MBEDTLS=OFF
      -DENABLE_OPENSSL=ON
      -DENABLE_TESTS_COMPONENT=OFF
    ]

    system "cmake", "-S", "bctoolbox", "-B", "build_bctoolbox", *args, *std_cmake_args
    system "cmake", "--build", "build_bctoolbox"
    system "cmake", "--install", "build_bctoolbox"
    prefix.install "bctoolbox/LICENSE.txt" => "LICENSE-bctoolbox.txt"

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{frameworks}" if OS.mac?

    system "cmake", "-S", (build.head? ? "ortp" : "."), "-B", "build_ortp", *args, *std_cmake_args
    system "cmake", "--build", "build_ortp"
    system "cmake", "--install", "build_ortp"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", *linker_flags
    system "./test"
  end
end
