class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.103/ortp-5.4.103.tar.bz2"
  sha256 "00bf3e47847f73b27eed4194a017d93b8765a5c3f4971d5e129b6d891ccc0a61"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06fd240ebd28a21bc9100661af6a5a6ee42de88532d35d837b166590bc3ab320"
    sha256 cellar: :any,                 arm64_sequoia: "ca3b4d4f8a099977de121f02c8ceabb73274ccdcc39fd865caf5e62e61d866ab"
    sha256 cellar: :any,                 arm64_sonoma:  "32df3b572103be5112f2d5ddfe1867e98870a40f185c5bf0f8fa376b9fbeae89"
    sha256 cellar: :any,                 sonoma:        "dbeb559f5386e9adb5e3aec84a2c1c69f9f5445eb53383f5357c590301b0cbe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf12e9d153eacf0b6fafd084e6bb821d595833f4ebe2df4e03a94a88d8709efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab62086738727e854b532b1d43de42690840332da00eb9d27c393197958c128"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.103/bctoolbox-5.4.103.tar.bz2"
    sha256 "29cc99240d5949ab37b241c3965963eab24b5a37e1609c3a7c184f9082abc850"

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
