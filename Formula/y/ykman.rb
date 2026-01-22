class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/b3/09/ba3ca95ed3c8adfb7f8288a33048a963dcc5741eb3e819a8451b65e36a59/yubikey_manager-5.8.0.tar.gz"
  sha256 "3af0da65e1fdd46763c94ee74e2da55a4b6e7771da776c197f5f4b4581738560"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d93f6407c3dae82d92052a1e0760697c2b38d10fa0b73c09bffecf50f829abcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4222550be02dc68325842f0e17c2c966cb1b8eb461c688059c8017bc5b728539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b13eca2812f39cd08bb1e1bce2db68b075cb61a3daadba2ddf74025ff27859"
    sha256 cellar: :any_skip_relocation, sonoma:        "f33032bc682ff08e443e9b0d40ee8969f6e6568c3de9a627e8f69082cbe56c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11aa2264ec26273507721ada76824e0457d036151dfe551e289a4932e92632e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af26ac4ca2a0ce6535d0d5ef6b93d35544af3ac3072073b7141bd8331c25f3b"
  end

  depends_on "cmake" => :build # for more-itertools
  depends_on "swig" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "pcsc-lite"

  pypi_packages exclude_packages: "cryptography",
                extra_packages:   %w[jeepney secretstorage]

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/e7/3c/c65377e48c144afca6b02c69f10c0fe936db556096a4e2c9798e2aa72db6/fido2-2.1.1.tar.gz"
    sha256 "f1379f845870cc7fc64c7f07323c3ce41e8c96c37054e79e0acd5630b3fec5ac"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/cb/9c/a788f5bb29c61e456b8ee52ce76dbdd32fd72cd73dd67bc95f42c7a8d13c/jaraco_context-6.1.0.tar.gz"
    sha256 "129a341b0a85a7db7879e22acd66902fda67882db771754574338898b2d5d86f"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/93/c9/65c68738a94b44b67b3c5e68a815890bbd225f2ae11ef1ace9b61fa9d5f3/pyscard-2.3.1.tar.gz"
    sha256 "a24356f57a0a950740b6e54f51f819edd5296ee8892a6625b0da04724e9e6c13"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    without = ["pyscard"]
    without += %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    # Use brewed swig
    # https://github.com/Homebrew/homebrew-core/pull/176069#issuecomment-2200583084
    # https://github.com/LudovicRousseau/pyscard/issues/169#issuecomment-2200632337
    resource("pyscard").stage do
      inreplace "pyproject.toml", 'requires = ["setuptools","swig"]', 'requires = ["setuptools"]'
      venv.pip_install Pathname.pwd
    end

    man1.install "man/ykman.1"
    generate_completions_from_executable(bin/"ykman", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
