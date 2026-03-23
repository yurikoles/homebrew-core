class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/39/fc/e05f4629ea01e0218c0858d4f1676349787558ce830b39c741ae169ea4a5/pipdeptree-2.34.0.tar.gz"
  sha256 "9a43a0b4a16a5cbc4e6ab02966dfd5411b949ff8c7cb1de7ade960bef2db3537"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dab79aedd5693868b53ed55c7959de08f3cecc127a2ffa6f6550d0b44f73eba"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
