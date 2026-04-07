class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  # TODO: Switch to monorepo in 5.5.x
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.4.105/ortp-5.4.105.tar.bz2"
  sha256 "11945a38b2fbce46b58dcdc46a2978371ab6a15f0c9c147e3412a01032ee6e93"
  license all_of: ["AGPL-3.0-or-later", "GPL-3.0-or-later"]
  head "https://gitlab.linphone.org/BC/public/linphone-sdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5cd5bee870100b0f705a0021361c502935ba88fa8ee411cba700dfd8e9e5385"
    sha256 cellar: :any,                 arm64_sequoia: "0b257cb88cbd1a66c8ddddf98459a14ff7cbda779e4bab0904026cabafcb3a8c"
    sha256 cellar: :any,                 arm64_sonoma:  "4199888921225fd1a9c499a26b428da0563e8ac7a731036238fa0ac58e4e2847"
    sha256 cellar: :any,                 sonoma:        "bdd59188f15332178bbcfc12b00816260cb9cd5832dde9ebeb8616bd00814ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f6447796ecedca837b8f3e848436c49e3bdf4e7f844fe13156aec20958df30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4027b0c012849ae05fbf1bbaa27af4be7be8c559207c6ad1f19d1d78a35f7e3b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.4.105/bctoolbox-5.4.105.tar.bz2"
    sha256 "1f549b96e626c0fad503e11e428b453a26e847214aed0d79176cf5ab23faae33"

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
