class Tinysparql < Formula
  desc "Low-footprint RDF triple store with SPARQL 1.1 interface"
  homepage "https://tinysparql.org/"
  url "https://download.gnome.org/sources/tinysparql/3.11/tinysparql-3.11.0.tar.xz"
  sha256 "011e758a53f31112a8c45700fd6039ae55617f0dac70119d9eddafc03cf68fe5"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/tinysparql.git", branch: "main"

  # TinySPARQL doesn't follow GNOME's "even-numbered minor is stable" version
  # scheme but they do appear to use 90+ minor/patch versions, which may
  # indicate unstable versions (e.g., 1.99.0, 2.2.99.0, etc.).
  livecheck do
    url "https://download.gnome.org/sources/tinysparql/cache.json"
    regex(/tinysparql[._-]v?(\d+(?:(?!\.9\d)\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "845cd93f5a701ab4297653c6ef23b242f5a2f4a820f8d61a26c06f2f4e570d5f"
    sha256 arm64_sequoia: "12534910709b1fc55e9b24854f918b6313da54fa04d9fdd64d4064f2d5e14301"
    sha256 arm64_sonoma:  "1346694737ed77c3df31cdd8311667510289a56237f0d0aa2383fce61cf32bce"
    sha256 sonoma:        "b9b30ec6e30f93fabd4b834821daed5ef87d0f4c20cc9ce7b660f7899eab4581"
    sha256 arm64_linux:   "fd75e5b220b81b87cdd19bf356eab55984992e3327b0dd885a818a9af332d654"
    sha256 x86_64_linux:  "af5e3d9e4f303698993dde336842e0dd37afc08f701ae88ca86c51693265cc25"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "icu4c@78"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "sqlite"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # TODO: Remove patches when fix is in a release.
  # https://gitlab.gnome.org/GNOME/tinysparql/-/merge_requests/808
  patch do
    url "https://gitlab.gnome.org/GNOME/tinysparql/-/commit/1219e5ff4c4ce3afcbc5161baa27ef54153b2a99.diff"
    sha256 "67f9780f4438906b55c7f295b5f7afde30faef0885f94209e6c52654ea5b75d6"
  end

  patch do
    url "https://gitlab.gnome.org/GNOME/tinysparql/-/commit/b139706196da17089dbd0b5ee0f8713d1d50264d.diff"
    sha256 "16ec2db418b424991fd0c45130ef328ff76d4f21a8e6dbab69bef439fc6d3ab0"
  end

  patch do
    url "https://gitlab.gnome.org/GNOME/tinysparql/-/commit/806771f99e42c0ee8c7d9b2f66f5d65241131ce8.diff"
    sha256 "23b7124ab989e416787d98727f40b291260f786622e4a9d414df403bea7e403d"
  end

  def install
    args = %w[
      -Dman=false
      -Ddocs=false
      -Dsystemd_user_services=false
      -Dtests=false
    ]

    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libtracker-sparql/tracker-sparql.h>

      gint main(gint argc, gchar *argv[]) {
        g_autoptr(GError) error = NULL;
        g_autoptr(GFile) ontology;
        g_autoptr(TrackerSparqlConnection) connection;
        g_autoptr(TrackerSparqlCursor) cursor;
        int i = 0;

        ontology = tracker_sparql_get_ontology_nepomuk();
        connection = tracker_sparql_connection_new(0, NULL, ontology, NULL, &error);

        if (error) {
          g_critical("Error: %s", error->message);
          return 1;
        }

        cursor = tracker_sparql_connection_query(connection, "SELECT ?r { ?r a rdfs:Resource }", NULL, &error);

        if (error) {
          g_critical("Couldn't query: %s", error->message);
          return 1;
        }

        while (tracker_sparql_cursor_next(cursor, NULL, &error)) {
          if (error) {
            g_critical("Couldn't get next: %s", error->message);
            return 1;
          }
          if (i++ < 5) {
            if (i == 1) {
              g_print("Printing first 5 results:");
            }

            g_print("%s", tracker_sparql_cursor_get_string(cursor, 0, NULL));
          }
        }

        return 0;
      }
    C

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    ENV.prepend_path "PKG_CONFIG_PATH", icu4c.opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs tracker-sparql-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
