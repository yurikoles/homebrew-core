class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"
  revision 5

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff790570b8a943bd1312bd198ef9610c6068a955ca903080150bb0e5190d32a7"
    sha256 cellar: :any,                 arm64_sequoia: "6f7a7d02d66a6aca5f6feb14e5355575524b404c5506674aeb6878f2fcb2fb9a"
    sha256 cellar: :any,                 arm64_sonoma:  "6d940c481acb8fe68989c2e5b7ac4a1db675a95f0062de6f4075a2e50405c4ba"
    sha256 cellar: :any,                 sonoma:        "a0d5666967fef1a0ab57a6ab443f8a65375f49a21eabe19fae3b03a0f0c448bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ca104b3c7fccfac6deb7ea38adc50187a87fba2ea34d6c7a4d42d4ed279600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82b324cd00950380dada756031cb4fe6f48400f563082f2bd4e650f38139d6e8"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.14"

  pypi_packages package_name:   "nanopb",
                extra_packages: "setuptools"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/53/b8/cda15d9d46d03d4aa3a67cb6bffe05173440ccf86a9541afaf7ac59a1b6b/protobuf-6.33.4.tar.gz"
    sha256 "dc2e61bca3b10470c1912d166fe0af67bfc20eb55971dcef8dfa48ce14f0ed91"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/86/ff/f75651350db3cf2ef767371307eb163f3cc1ac03e16fdf3ac347607f7edb/setuptools-80.10.1.tar.gz"
    sha256 "bf2e513eb8144c3298a3bd28ab1a5edb739131ec5c22e045ff93cd7f5319703a"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-Dnanopb_PYTHON_INSTDIR_OVERRIDE=#{venv.site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    PROTO

    system Formula["protobuf"].bin/"protoc", "--proto_path=#{testpath}",
                                             "--plugin=#{bin}/protoc-gen-nanopb",
                                             "--nanopb_out=#{testpath}",
                                             testpath/"test.proto"
    assert_match "Test", (testpath/"test.pb.c").read
    assert_match "Test", (testpath/"test.pb.h").read
  end
end
