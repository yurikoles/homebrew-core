class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.110/ortp-5.4.110.tar.bz2"
  sha256 "559f4153078fc843ed539e738b81b799676b9221ec69dae3dc577fbfbaf40cd9"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2c15b0839e20e98fe0ea2794741ec1f467a15d88ff357c43a4d5b05bc6c0b82"
    sha256 cellar: :any,                 arm64_sequoia: "d0c6ff4762e496cd78d53552d8ff38900179c1d643663fb478bcd55db67cec9a"
    sha256 cellar: :any,                 arm64_sonoma:  "f0fe9cfab0bba6d2133fead1e6ad58163d5dadc66baae92c81d9c9dd79c01047"
    sha256 cellar: :any,                 sonoma:        "f4b4cdf2f72a89d9435e370c610f7953ffc00e0e52d8299d4ce2c357953ecf1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c2d63ba937a77202765495c5338f6afa2d367dc0f14945d82a9b0bbf3724a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f511e9b825d860a75ec46fc3984e59d5bc8a4d065e4a021e6343cb914badb84"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.110/bctoolbox-5.4.110.tar.bz2"
    sha256 "5bccd2e5d850d122948b28f50614d70caaa066f32d6d22a03dd6394c7b26c7fd"

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
