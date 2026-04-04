class Overturemaps < Formula
  include Language::Python::Virtualenv

  desc "Python tools for interacting with Overture Maps data"
  homepage "https://overturemaps.org"
  url "https://files.pythonhosted.org/packages/2e/f6/e220c4026bbb425e9c7e0ca02237308dad69598449d4dcf5229f2a60d213/overturemaps-0.20.0.tar.gz"
  sha256 "aef735329a827511ae3164b90920debfd485832557f15733a295d4fe5580cb18"
  license "MIT"
  head "https://github.com/OvertureMaps/overturemaps-py.git", branch: "main"

  depends_on "cmake" => :build  # for pyarrow
  depends_on "ninja" => :build  # for pyarrow
  depends_on "rust" => :build   # for orjson
  depends_on "apache-arrow"
  depends_on "geos"             # for shapely
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  pypi_packages exclude_packages: "numpy"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/9d/1b/2024d06792d0779f9dbc51531b61c24f76c75b9f4ce05e6f3377a1814cea/orjson-3.11.8.tar.gz"
    sha256 "96163d9cdc5a202703e9ad1b9ae757d5f0ca62f4fa0cc93d1f27b0e180cc404e"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/01/33/ffd9c3eb087fa41dd79c3cf20c4c0ae3cdb877c4f8e1107a446006344924/pyarrow-23.0.0.tar.gz"
    sha256 "180e3150e7edfcd182d3d9afba72f7cf19839a497cc76555a8dce998a8f67615"
  end

  resource "shapely" do
    url "https://files.pythonhosted.org/packages/4d/bc/0989043118a27cccb4e906a46b7565ce36ca7b57f5a18b78f4f1b0f72d9d/shapely-2.1.2.tar.gz"
    sha256 "2ed4ecb28320a433db18a5bf029986aa8afcfd740745e78847e330d5d94922a9"
  end

  def python3
    "python3.14"
  end

  def install
    # The sdist has reproducible-build timestamps from 2020-02-02, which causes
    # Homebrew to set SOURCE_DATE_EPOCH to that date. This makes pip restrict
    # package downloads to pre-2020, breaking all modern build backends.
    # Reset to current time so the 24-hour safety window works as intended.
    ENV["SOURCE_DATE_EPOCH"] = Time.now.utc.to_i.to_s

    numpy_include = Formula["numpy"].opt_lib/Language::Python.site_packages(python3)/"numpy/_core/include"
    geos_include = Formula["geos"].opt_include
    geos_lib = Formula["geos"].opt_lib

    ENV.prepend "CFLAGS", "-I#{numpy_include} -I#{geos_include}"
    ENV.prepend "LDFLAGS", "-L#{geos_lib}"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overturemaps --version")
    output = shell_output("#{bin}/overturemaps download 2>&1", 2)
    assert_match "Missing option", output
  end
end
