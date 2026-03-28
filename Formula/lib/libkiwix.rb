class Libkiwix < Formula
  desc "Common code base for all Kiwix ports"
  homepage "https://github.com/kiwix/libkiwix"
  url "https://github.com/kiwix/libkiwix/archive/refs/tags/14.2.0.tar.gz"
  sha256 "244b69120d132de3079774ee439f9adfb7b556e88b9ef6ce5300f37dfc3737bc"
  license "GPL-3.0-or-later"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
  depends_on "libmicrohttpd"
  depends_on "libzim"
  depends_on "pugixml"
  depends_on "xapian"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # TODO: separate as a new formula once upstream release a new tag
  resource "mustache" do
    url "https://github.com/kainjow/Mustache/archive/refs/tags/v4.1.tar.gz"
    sha256 "acd66359feb4318b421f9574cfc5a511133a77d916d0b13c7caa3783c0bfe167"
  end

  def install
    resource("mustache").stage do
      (buildpath/"mustache").install "mustache.hpp"
    end

    ENV.append_to_cflags "-I#{buildpath}/mustache"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kiwix/kiwix_config.h>
      #include <kiwix/library.h>
      #include <kiwix/manager.h>
      #include <iostream>

      int main() {
        std::cout << "libkiwix " << LIBKIWIX_VERSION << std::endl;

        // Verify Library creation and initial empty state
        auto lib = kiwix::Library::create();
        if (lib->getBookCount(true, true) != 0) return 1;

        // Parse a library XML string and verify book metadata is stored correctly
        const std::string xml = R"(
          <library version="1.0">
            <book id="test-id-001"
                  path="test.zim"
                  url="https://example.com/test.zim"
                  title="Test Book Title"
                  language="eng"
                  creator="Test Creator"
                  publisher="Test Publisher"
                  date="2024-01-01"
                  name="test_zim"
                  articleCount="42"
                  mediaCount="5"
                  size="1024">
            </book>
          </library>)";

        kiwix::Manager manager(lib);
        if (!manager.readXml(xml, true, "", true)) return 1;
        if (lib->getBookCount(true, true) != 1) return 1;

        kiwix::Book book = lib->getBookByIdThreadSafe("test-id-001");
        if (book.getTitle() != "Test Book Title") return 1;
        if (book.getCreator() != "Test Creator") return 1;
        if (book.getArticleCount() != 42) return 1;

        std::cout << "Library/Manager test passed" << std::endl;
        return 0;
      }
    CPP

    icu4c = Formula["icu4c@78"]
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test", "-I#{include}", "-I#{icu4c.opt_include}",
                    "-L#{lib}", "-L#{icu4c.opt_lib}", "-lkiwix"

    output = shell_output("./test")
    assert_match "libkiwix #{version}", output
    assert_match "Library/Manager test passed", output
  end
end
