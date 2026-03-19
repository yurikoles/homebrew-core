class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/releases/download/13.2.0/harfbuzz-13.2.0.tar.xz"
  sha256 "974fbc0da97242d0f029befbf441eab304bd68d951b7529b5cba94195b078300"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dffcca2859a77e0ff68c42cb324c7e4dfe1a201e91c47dab8167bfa6ba777295"
    sha256 cellar: :any, arm64_sequoia: "e186ca095e7292454b07cf39d24553d6261a79ec2bcf61b9a39256c12c485d9f"
    sha256 cellar: :any, arm64_sonoma:  "1ed3e8e04cc77d95d3585e84d41009a4bc32bf43f92996c3232f0729d61407a0"
    sha256 cellar: :any, sonoma:        "a5dfc163b3aded63748e657bbec5bfcf021df52cb09be619ad23f92d98d64c77"
    sha256               arm64_linux:   "eae9d43969eb1e4be3a512ad2f385cd959bd7d5905a58a364f3f9c02dffb1296"
    sha256               x86_64_linux:  "e7b35eab70c357df2b61a999b7c768207536cd3458fcda759d9b2bfc76033f63"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "pygobject3" => :test
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "graphite2"
  depends_on "icu4c@78"
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      --default-library=both
      -Dcairo=enabled
      -Dcoretext=enabled
      -Dfreetype=enabled
      -Dglib=enabled
      -Dgobject=enabled
      -Dgraphite=enabled
      -Dicu=enabled
      -Dintrospection=enabled
      -Dtests=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-test-ttf" do
      url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
      sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
    end

    resource("homebrew-test-ttf").stage do
      shape = pipe_output("#{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf", "സ്റ്റ്").chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
    system "python3.14", "-c", "from gi.repository import HarfBuzz"
  end
end
