class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng/"
  url "https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v0.9.tar.gz"
  sha256 "d7463da4b50924a385e306f585bb05dbe58e212ba846f8593c3b2bd31c6cb46b"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/stevegrubb/libcap-ng.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d83b347391dd5f031ef8fe8d5762f5aeb678b27e4d18da173c8705813e068c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a17a6bf3d9aa3735db67bde8d609883a0d945ae3fb296d4e4f990e957e0eceb6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "swig" => :build
  depends_on :linux

  def python3
    "python3.14"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-python3",
                          *std_configure_args
    system "make", "install", "py3execdir=#{prefix/Language::Python.site_packages(python3)}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cap-ng.h>

      int main(int argc, char *argv[])
      {
        if(capng_have_permitted_capabilities() > -1)
          printf("ok");
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcap-ng", "-o", "test"
    assert_equal "ok", `./test`
    system python3, "-c", "import capng"
  end
end
