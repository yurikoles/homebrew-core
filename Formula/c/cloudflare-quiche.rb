class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.28.0",
      revision: "a9cb314563a5c13791bd7e5a1e32821e53114e75"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "404a87341318e9f978e0229de961d408cbd3e04be15ac022248251b8f14583e9"
    sha256 cellar: :any,                 arm64_sequoia: "61138fd9eb576fe8695a23878cb1e4033078855df6dd57e1434f993173c05d23"
    sha256 cellar: :any,                 arm64_sonoma:  "facb3558ee48cf53fd47dc1c23689d9ea274b06a27ffc4c19cf2c1f28830efd5"
    sha256 cellar: :any,                 sonoma:        "aa144df57d18c031b745121d5299fee30e94b80ff97d5fb2723c174c1d921a39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd9d66eda6f058282b9fe93ac8a97115db93fa2ea22bbeef06a2eb67c13d115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590dc99d7ba6023e6674b842b45368620b3e5959406ceb38741f485d544844ac"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")

    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--features", "ffi,pkg-config-meta", "--release"
    lib.install "target/release/libquiche.a"
    include.install "quiche/include/quiche.h"

    # install dylib with version and symlink
    full_versioned_dylib = shared_library("libquiche", version.major_minor_patch.to_s)
    lib.install "target/release/#{shared_library("libquiche")}" => full_versioned_dylib
    lib.install_symlink full_versioned_dylib => shared_library("libquiche")
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major.to_s)
    lib.install_symlink full_versioned_dylib => shared_library("libquiche", version.major_minor.to_s)

    # install pkgconfig file
    pc_path = "target/release/quiche.pc"
    # the pc file points to the tmp dir, so we need inreplace
    inreplace pc_path do |s|
      s.gsub!(/includedir=.+/, "includedir=#{include}")
      s.gsub!(/libdir=.+/, "libdir=#{lib}")
    end
    (lib/"pkgconfig").install pc_path
  end

  test do
    assert_match "your browser used <strong>HTTP/3</strong>",
                 shell_output("#{bin}/quiche-client https://cloudflare-quic.com/")
    (testpath/"test.c").write <<~C
      #include <quiche.h>
      int main() {
        quiche_config *config = quiche_config_new(0xbabababa);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lquiche", "-o", "test"
    system "./test"
  end
end
