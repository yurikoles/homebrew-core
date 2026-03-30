class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.36/gtk-doc-1.36.0.tar.xz"
  sha256 "3b84bac36efbe59017469040dfee58f17cf0853b5f54dfae26347daf55b6d337"
  license "GPL-2.0-or-later"
  revision 1

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa4545c0ed0e71de8cbe8111a291f999bc475f9e06a4a296e0ad29ca582793e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "870df07ab7d1912d6341c2c9d1d966b68097ddbf5b6d850db22b614ed6758779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "127d1017a9d1f754fc4da80ca9c8a1ac63305510255057d461bff1e8762af00f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a6a6940b7af87fa5348ab9822a2ca0f9ad662e6e934623218c5d76f3b7c1761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45a6ff0c8d8cce8cec896c6c095915ae1e0b63443b4bd3b0d5f046c4f4bcc421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf787ae2f1dd3833a27d9d3ea41ce8363ff9f7ce7f9b09493b784c81382d363"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages package_name:   "",
                extra_packages: %w[lxml pygments]

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkgconf"].bin

    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", "setup", "build", "-Dtests=false", "-Dyelp_manual=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
