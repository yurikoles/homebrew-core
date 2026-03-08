class Zvbi < Formula
  desc "Vertical Blanking Interval (VBI) decoding library"
  homepage "https://github.com/zapping-vbi/zvbi"
  url "https://github.com/zapping-vbi/zvbi/archive/refs/tags/v0.2.44.tar.gz"
  sha256 "bca620ab670328ad732d161e4ce8d9d9fc832533cb7440e98c50e112b805ac5e"
  license "GPL-2.0-or-later"
  head "https://github.com/zapping-vbi/zvbi.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "libpng"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libzvbi.h>
      #include <stdio.h>

      int main() {
        unsigned int major, minor, micro;
        vbi_version(&major, &minor, &micro);
        printf("%u.%u.%u\\n", major, minor, micro);

        vbi_decoder *dec = vbi_decoder_new();
        if (!dec) {
          fprintf(stderr, "vbi_decoder_new failed\\n");
          return 1;
        }
        vbi_decoder_delete(dec);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzvbi", "-I#{include}", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
