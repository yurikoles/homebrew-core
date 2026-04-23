class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/46/60/d03d52e6690d4e9caf333dcd14550cde634ce6c118b3bc8fa3112c3186fd/pyinstaller-6.20.0.tar.gz"
  sha256 "95c5c7e03d5d61e9dfb8ef259c699cf492bb1041beb6dbe83696608cec07347a"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44a696fd78cacec38fa8fecaea843f65bdb3e03c3ddfaaefcc0c0cd0c72ab872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd2f2dfd000c56a1db5c39b5aadf7bc554aab42d93036d23835ef4639eb6de80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda92fa93b71941c60448a24c28a0f10b4c39ee041f3345aa503c43776870f20"
    sha256 cellar: :any_skip_relocation, tahoe:         "cf54dbf3b85768d852b5ab5a8c5bce0a33117b757fa7a59fa9233e4356fcd834"
    sha256 cellar: :any_skip_relocation, sequoia:       "28c1b664cb04e1ee950e720c89a5fcad78f99047ef30f5d0ceb8b04455c07b92"
    sha256 cellar: :any_skip_relocation, sonoma:        "4249f190ff12fa683732b5cf8cfc371a1c9eb1f5600b9a8359df9b7af35eb6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da47ef2ff3cf07b031384bbc51ae8dad8267bea9674afea3905e1f721bac71dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce89a7bde964bd597e0bd93fc18bc39f4659f813c711ffd329f0a4999618c18e"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages extra_packages: "macholib"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/7e/f8/97fdf103f38fed6792a1601dbc16cc8aac56e7459a9fff08c812d8ae177a/altgraph-0.17.5.tar.gz"
    sha256 "c87b395dd12fabde9c99573a9749d67da8d29ef9de0125c7f536699b4a9bc9e7"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/10/2f/97589876ea967487978071c9042518d28b958d87b17dceb7cdc1d881f963/macholib-1.16.4.tar.gz"
    sha256 "f408c93ab2e995cd2c46e34fe328b130404be143469e41bc366c807448979362"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/de/0d2b39fb4af88a0258f3bac87dfcbb48e73fbdea4a2ed0e2213f9a4c2f9a/packaging-26.1.tar.gz"
    sha256 "f042152b681c4bfac5cae2742a55e103d27ab2ec0f3d88037136b6bfe7c9c5de"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/c7/fe/9278c29394bf69169febc21f96b4252c3ee7c8ec22c2fc545004bed47e71/pyinstaller_hooks_contrib-2026.4.tar.gz"
    sha256 "766c281acb1ecc32e21c8c667056d7ebf5da0aabd5e30c219f9c2a283620eeaa"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  def install
    cd "bootloader" do
      system "python3.14", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    without = ["macholib"] unless OS.mac?
    virtualenv_install_with_resources(without:)
  end

  test do
    (testpath/"easy_install.py").write <<~PYTHON
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    PYTHON
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_path_exists testpath/"dist/easy_install"
  end
end
