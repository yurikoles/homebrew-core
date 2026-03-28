class Moarvm < Formula
  desc "VM with adaptive optimization and JIT compilation, built for Rakudo"
  homepage "https://moarvm.org"
  url "https://github.com/MoarVM/MoarVM/releases/download/2026.03/MoarVM-2026.03.tar.gz"
  sha256 "67fdab474d0041df7003235108a4c31bbb0e4b5c7c88bba204520e6488aefcb6"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3a01dcd9b0e7724c7c7ce0eed616035551fa8d63f3a3145ab3d04aaadddb7657"
    sha256 arm64_sequoia: "9c785039286a06f0ae67d59ef3be73d6f3db5494f3635ee6be9c52c0920ca4f7"
    sha256 arm64_sonoma:  "4e93c425597de585ad2dadee28769c5f21e76a133b20f50ba28e492811272a86"
    sha256 sonoma:        "c7ac78f36200c9def93cdd612e5cfb7cf1bf67acc7af2b18fec18abd8bfa87f0"
    sha256 arm64_linux:   "456708dc93d5aa5dac0b477f0e603d893ee3c67403d355471d93c33f558ce510"
    sha256 x86_64_linux:  "4e6449e114d379f2edb191f46998174473d6ce739edbc663f7a3260c53d163b4"
  end

  depends_on "pkgconf" => :build
  depends_on "libtommath"
  depends_on "mimalloc"
  depends_on "zstd"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  on_macos do
    depends_on "libuv"
  end

  conflicts_with "moor", because: "both install `moar` binaries"
  conflicts_with "rakudo-star", because: "rakudo-star currently ships with moarvm included"

  resource "nqp" do
    url "https://github.com/Raku/nqp/releases/download/2026.03/nqp-2026.03.tar.gz"
    sha256 "e7c15fcb5a77a6b5295dba68a9bd3a2d3151a66851e1f82f7e8e701741c97da5"

    livecheck do
      formula :parent
    end
  end

  def install
    # Remove bundled libraries
    %w[dyncall libatomicops libtommath mimalloc].each { |dir| rm_r("3rdparty/#{dir}") }

    configure_args = %W[
      --c11-atomics
      --has-libffi
      --has-libtommath
      --has-mimalloc
      --optimize
      --pkgconfig=#{Formula["pkgconf"].opt_bin}/pkgconf
      --prefix=#{prefix}
    ]
    # FIXME: brew `libuv` causes runtime failures on Linux, e.g.
    # "Cannot find method 'made' on object of type NQPMu"
    if OS.mac?
      configure_args << "--has-libuv"
      rm_r("3rdparty/libuv")
    end

    system "perl", "Configure.pl", *configure_args
    system "make", "realclean"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("nqp")
    out = Dir.chdir("src/vm/moar/stage0") do
      shell_output("#{bin}/moar nqp.moarvm -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    end
    assert_equal "0123456789", out
  end
end
