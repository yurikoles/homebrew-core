class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/releases/download/v20.2.8/source-full.tar.gz"
  sha256 "19af864589fd5f264e59a2741191973cedd4a989197aa2a33f3f08df9d06ca84"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ededdf7df1f5c0c1a01158004a5f2252489e4bdb24179ab5f4868831ec5d480"
    sha256 cellar: :any,                 arm64_sequoia: "e82f51708078975a08847fc8c090a08dcd83c2b51bf94cbe9f3eb7804d2c3828"
    sha256 cellar: :any,                 arm64_sonoma:  "ae0bf4743cb0b27f3bc0e3043749acb49479ce85c518a41b862ddc03a6bc5c78"
    sha256 cellar: :any,                 sonoma:        "9e4788240625afd1383b69041a37ca7afea493da2e2df1f8c924a26d945446a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "361d773347c55484e272030c2228c1f1882d60b16bc762146fefd580cbff6785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2c612e06375da2987428d8ebddb67154e5d9fa3ac7b93d942c3079e99cf7c97"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "exiftool" => :test
  depends_on "fmt"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
    depends_on "xz"
    depends_on "zstd"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1699
    cause "Requires C++20"
  end

  # https://github.com/GrokImageCompression/grok/blob/master/INSTALL.md#compilers
  fails_with :gcc do
    version "9"
    cause "GNU compiler version must be at least 10.0"
  end

  def install
    # Ensure we use Homebrew libraries
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath/"thirdparty"/l) }

    args = %w[
      -DGRK_BUILD_DOC=ON
      -DGRK_BUILD_JPEG=OFF
      -DGRK_BUILD_LCMS2=OFF
      -DGRK_BUILD_LIBPNG=OFF
      -DGRK_BUILD_LIBTIFF=OFF
      -DSPDLOG_FMT_EXTERNAL=ON
    ]

    if OS.mac? && MacOS.version <= :catalina
      # Workaround Perl 5.18 issues with C++11: pad.h:323:17: error: invalid suffix on literal
      ENV.append "CXXFLAGS", "-Wno-reserved-user-defined-literal"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"
  end

  test do
    resource "homebrew-test_image" do
      url "https://github.com/GrokImageCompression/grok-test-data/raw/43ce4cb/input/nonregression/basn6a08.tif"
      sha256 "d0b9715d79b10b088333350855f9721e3557b38465b1354b0fa67f230f5679f3"
    end

    (testpath/"test.c").write <<~C
      #include <grok/grok.h>

      int main () {
        grk_image_comp cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space, true);

        grk_object_unref(&image->obj);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"

    # Test metadata preservation
    testpath.install resource("homebrew-test_image")
    system bin/"grk_compress", "--in-file", "basn6a08.tif",
                               "--out-file", "test.jp2", "--out-fmt", "jp2"
    output = shell_output("#{Formula["exiftool"].bin}/exiftool test.jp2")

    expected_fields = [
      "Capture X Resolution            : 2835",
      "Capture Y Resolution            : 2835",
      "Capture X Resolution Unit       : m",
      "Capture Y Resolution Unit       : m",
    ]

    expected_fields.each do |field|
      assert_match field, output
    end
  end
end
