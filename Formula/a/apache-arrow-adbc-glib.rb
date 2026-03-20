class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-23/apache-arrow-adbc-23.tar.gz"
  sha256 "c74059448355681bf306008e559238ade40af01658d6a8f230b8da34d9a40de9"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "apache-arrow-adbc"
  depends_on "apache-arrow-glib"
  depends_on "glib"

  def install
    system "meson", "setup", "build", "glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <adbc-glib/adbc-glib.h>
      int main(void) {
        GError *error = NULL;
        GADBCDatabase *database = gadbc_database_new(&error);
        if (database) {
          g_object_unref(database);
        }
        return error ? 1 : 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs adbc-glib gobject-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
