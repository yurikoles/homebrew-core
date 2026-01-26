class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/releases/download/v6.2.1/universal-ctags-6.2.1.tar.gz"
  sha256 "2c63efe9e0e083dc50e6fdd8c5414781cc8873d8c8940cf553c01870ed962f8c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "997619dc5d8a09df1cd353bbe24fa9d0a6246dc7ab87c2f1850ca7d969f6bb4d"
    sha256 cellar: :any,                 arm64_sequoia: "3f4b8cd92b67750b15963cfc6011915c96528f2a87207ff9b2963c41e51bd2d9"
    sha256 cellar: :any,                 arm64_sonoma:  "d0aba5fba5032ac9b829e0a108cd8226d5d6066c67ba5623e1d39655bef0ed93"
    sha256 cellar: :any,                 sonoma:        "8399abb0635d1846504913c106b710385ec0c1409d0e4c682c27bc1e939a313c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51140552e4970aace5cfdcff7b1eedc76e7cb5ad8fcbde19195182c6cd6c3b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "295d8b4be91bd542854afbe09ec71bc56cb1fe07a99f34e8528baf6e2ee37535"
  end

  head do
    url "https://github.com/universal-ctags/ctags.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    C
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
