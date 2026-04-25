class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/22/32/708bedc9dde7b328d45abbc076091769d44f2f24ad151ad92d56a6ec142b/pymupdf-1.27.2.3.tar.gz"
  sha256 "7a92faa25129e8bbec5e50eeb9214f187665428c31b05c4ef6e36c58c0b1c6d2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "124e64afbc02bf5889b6d9188cb75873e304dec10b51f8dd842ce3f6fd25eaa3"
    sha256 cellar: :any,                 arm64_sequoia: "a74500cd3038757634029e6c9ee16d65c5dbfb714088f345093e25a2ab37fbcc"
    sha256 cellar: :any,                 arm64_sonoma:  "c82f493fa1bef8021b24b3585a075fd85a9c1e955cd91e1415404f334e86da36"
    sha256 cellar: :any,                 sonoma:        "9d10e5d2d4fd40cc2c6205fceed2b32e051adbae2d186426177e68dcbc557702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03781d1ec2924c780e7be9a6a7670cae16091ccfaca120dae574483ec1976c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07647c4cbbf233516d4f5edb60a29006a4e5691ffe36dc0a6482eaf51aa33608"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_SETUP_SWIG"] = Formula["swig"].opt_bin/"swig"

    mupdf_libpath = Formula["mupdf"].opt_lib.to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import sys
      from pathlib import Path

      import fitz

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = fitz.open(in_pdf)
      pdf_page = pdf_doc.load_page(0)
      png_bytes = pdf_page.get_pixmap().tobytes()

      Path(out_png).write_bytes(png_bytes)
    PYTHON

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_path_exists out_png
  end
end
