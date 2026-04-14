class TerraformLocal < Formula
  include Language::Python::Virtualenv

  desc "CLI wrapper to deploy your Terraform applications directly to LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/b9/f7/7d128b483dfd03d178c37eedc8c9329d7ee0abc4781bcfe5a0069ee63d79/terraform_local-0.26.0.tar.gz"
  sha256 "958abac78c40b15fca6edcd833a9706a28e1cc861cb713e3fed5def345d518b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7769f93ae62ca92910ef74f677fac98177afa1ae13ccfab7bf17b8e0f6902ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c03964a59358decef8c9ee58b926f00639c301a7858164e9c64a2348a632cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013ccf77eac65fa641c456e6fa88ec890b078273e4def36dc02ce616ab6e4aa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4948a1fae033c666952dfa09f984a0ee5314158136da64d1e51f154ccdc479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e71ac39baa41b11fcfb11454020ad8cea46f6f2ef9f73045108ae6528914666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05032bd60ac470f02aea4d768c57d94ceb890db6e6d5960f326aaadbc9c6d123"
  end

  depends_on "python@3.14"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/da/bb/7d4435cca6fccf235dd40c891c731bcb9078e815917b57ebadd1e0ffabaf/boto3-1.42.88.tar.gz"
    sha256 "2d22c70de5726918676a06f1a03acfb4d5d9ea92fc759354800b67b22aaeef19"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/50/87966238f7aa3f7e5f87081185d5a407a95ede8b551e11bbe134ca3306dc/botocore-1.42.88.tar.gz"
    sha256 "cbb59ee464662039b0c2c95a520cdf85b1e8ce00b72375ab9cd9f842cc001301"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/44/79/d240524248f0e675982c52586d67ea5030cf7511af9dbc8814e1d100cd15/localstack_client-2.11.tar.gz"
    sha256 "1cbd7bf1f03b9b553ffe7ea10fe137f44e8d690a37af9c6515eba61a2379fc46"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-hcl2" do
    url "https://files.pythonhosted.org/packages/39/7b/6c9c973484a482f833a1b88ab69e078e05cc1f761af1839d5cbe7e7fad92/python_hcl2-8.1.2.tar.gz"
    sha256 "ae809c7e6e39e8c3c3555e7b7f389082207929591fcba062c9f76afb1abe972d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cb/0e/3a246dbf05666918bd3664d9d787f84a9108f6f43cc953a077e4a7dfdb7e/regex-2026.4.4.tar.gz"
    sha256 "e08270659717f6973523ce3afbafa53515c4dc5dcad637dc215b6fd50f689423"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/05/04/74127fc843314818edfa81b5540e26dd537353b123a4edc563109d8f17dd/s3transfer-0.16.0.tar.gz"
    sha256 "8e990f13268025792229cd52fa10cb7163744bf56e719e0b9cb925ab79abf920"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/tflocal state list 2>&1", 1)
    assert_match(/No such file or directory|No state file was found/, output)
  end
end
