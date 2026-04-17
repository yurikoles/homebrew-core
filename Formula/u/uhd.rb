class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.9.0.1.tar.gz"
  sha256 "0be26a139f23041c1fb6e9666d84cba839460e3c756057dc48dc067cc356a7bc"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "261b880284b0af7ee4fedeb3134ecd8650705ef53640091f057cf154be874d74"
    sha256                               arm64_sequoia: "9a1bf679d3a4cb9b77b1fdb8df6ed88f642f67fe2f44f739db1a9887733e6092"
    sha256                               arm64_sonoma:  "4118498bcec6d6fc7f58be464dba95c87f23539d762d5c11b51e303e3f747ca7"
    sha256                               sonoma:        "2111c2fd0c29de1e19977e5908c3be0bf4d6127e1168a3dca696e194fdba38c2"
    sha256                               arm64_linux:   "13a26ca46463c3c1e3656d25964804717fad9d64ab447f4df47dc36686acb58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c13c228c82b67efe6e41031441f501faef05b9efcb7c9fc47baee7b43abc4a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.14"

  on_linux do
    depends_on "ncurses"
  end

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/59/8a/805404d0c0b9f3d7a326475ca008db57aea9c5c9f2e1e39ed0faa335571c/mako-1.3.11.tar.gz"
    sha256 "071eb4ab4c5010443152255d77db7faa6ce5916f35226eb02dc34479b6858069"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = %W[
      -DENABLE_TESTS=OFF
      -DUHD_VERSION=#{version}
    ]
    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
