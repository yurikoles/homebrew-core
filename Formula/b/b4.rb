class B4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with public-inbox and patch archives"
  homepage "https://b4.docs.kernel.org/en/latest/"
  url "https://files.pythonhosted.org/packages/c3/34/7f17fce52acb992d7b70aaa956e6dec4dc432ce8d195a176f232fcd6315c/b4-0.15.2.tar.gz"
  sha256 "b815f2aed2288718cfe2a14c76421a00bc4f0918ea32b45dd1645c999fdda69d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04df938b9bdb395cc624cd729897721f1532ba3e064f6c13bb558cb82ef7008b"
    sha256 cellar: :any,                 arm64_sequoia: "e965a5c051c4a24fa07a0cb1d635f5ba1a7bfda7d8bff705fcb39d754c9e7f1c"
    sha256 cellar: :any,                 arm64_sonoma:  "e7a222c8a0967c041d7eff4965a2e695b9ffb810380c5eace756d93095fafbf9"
    sha256 cellar: :any,                 sonoma:        "52721b4552fb4ca2222ebf4d0ec7c747a5b99f4ca5bec9b52aa4c46e51e7e0e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb730ad2178b7e153fcf7a0af708139fa423771f21945dda904c2dacc469ea0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dea04ec2535e960bf25f0f8581e878241b76be66fab0a11e559727599eb63d0"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "cffi"]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "git-filter-repo" do
    url "https://files.pythonhosted.org/packages/b9/bb/7a283f568af6b0528ade65e8ace84bd6ba46003e429101bcd62c232d01a5/git_filter_repo-2.47.0.tar.gz"
    sha256 "411b27e68a080c07a69c233cb526dbc2d848b09a72f10477f4444dd0822cf290"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "patatt" do
    url "https://files.pythonhosted.org/packages/17/f9/d9c3ace058873379cec76fbe2ed887e8d47e55d56704018c29b35e30e440/patatt-0.7.0.tar.gz"
    sha256 "f7b2be8a15f251fbbc90c6b734ab910654a7a9d184369ce9e77b6d26e43b9eea"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4 --version")

    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Homebrew
        email = foo@brew.sh
    EOS
    assert_match "No thanks necessary.", shell_output("#{bin}/b4 ty 2>&1")
  end
end
