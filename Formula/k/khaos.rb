class Khaos < Formula
  include Language::Python::Virtualenv

  desc "Kafka traffic simulator for observability and chaos engineering"
  homepage "https://github.com/aleksandarskrbic/khaos"
  url "https://files.pythonhosted.org/packages/7f/0c/932228842cb6c0357fa4f41c5e68afaf3b41b7698f0794af300533594432/khaos_cli-0.7.1.tar.gz"
  sha256 "f5eb232f427dab15bbaa7ff8200a17d04c036a695c1c614e862bf87d93917b20"
  license "Apache-2.0"
  revision 5
  head "https://github.com/aleksandarskrbic/khaos.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1592515c8e39b1c84aa87e9dbdf8c0e22b21f9f53705080ec95e04416e553031"
    sha256 cellar: :any,                 arm64_sequoia: "3c75ee048b361b2c0cb7aa8f1a824596662b5266637a32655322459c9eed3780"
    sha256 cellar: :any,                 arm64_sonoma:  "c4c70d6bd183eaf145a704a32ad4a056be6fff4e831f07e1d814ac804af49d29"
    sha256 cellar: :any,                 sonoma:        "35fb486ce6fd7c647a2da24f93a01b3fbb26381feb2af393f3ddaa9c7bad90e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "700acddba1c4557c738668fd4f22ed18a60581dd20332cec3dc5f00d03917ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75c4dd5c0cc62bae33c56bcf536494de91ac8077ee69aad04b36d24d29097a32"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "librdkafka"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/28/10/b325d58ffe86815b399334a101e63bc6fa4e1953921cb23703b48a0a0220/authlib-1.6.11.tar.gz"
    sha256 "64db35b9b01aeccb4715a6c9a6613a06f2bd7be2ab9d2eb89edd1dfc7580a38f"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/af/dd/57fe3fdb6e65b25a5987fd2cdc7e22db0aef508b91634d2e57d22928d41b/cachetools-7.0.5.tar.gz"
    sha256 "0cd042c24377200c1dcd225f8b7b12b0ca53cc2c961b43757e774ebe190fd990"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/57/75/31212c6bf2503fdf920d87fee5d7a86a2e3bcf444984126f13d8e4016804/click-8.3.2.tar.gz"
    sha256 "14162b8b3b3550a7d479eafa77dfd3c38d9dc8951f6f69c78913a8f9a7540fd5"
  end

  resource "confluent-kafka" do
    url "https://files.pythonhosted.org/packages/40/52/2c71d8e0b2de51076f90cea05342dc9c20fa14ded11992827680db4bbdfa/confluent_kafka-2.14.0.tar.gz"
    sha256 "34efddfd06766d1153d10a70c23a98f6035e253a906db8ed04cb0249fc3b0fd2"
  end

  resource "faker" do
    url "https://files.pythonhosted.org/packages/89/95/4822ffe94723553789aef783104f4f18fc20d7c4c68e1bbd633e11d09758/faker-40.13.0.tar.gz"
    sha256 "a0751c84c3abac17327d7bb4c98e8afe70ebf7821e01dd7d0b15cd8856415525"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/65/8b/fa2d3287fd2267be6261d0177c6809a7fa12c5600ddb33490c8dc29e77b2/fastavro-1.12.1.tar.gz"
    sha256 "2f285be49e45bc047ab2f6bed040bb349da85db3f3c87880e4b92595ea093b2b"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/20/18/a746c8344152d368a5aac738d4c857012f2c5d1fd2eac7e17b647a7861bd/googleapis_common_protos-1.74.0.tar.gz"
    sha256 "57971e4eeeba6aad1163c1f0fc88543f965bb49129b8bb55b2b7b26ecab084f1"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/6b/6b/a0e95cad1ad7cc3f2c6821fcab91671bd5b78bd42afb357bb4765f29bc41/protobuf-7.34.1.tar.gz"
    sha256 "9ce42245e704cc5027be797c1db1eb93184d44d1cdd71811fb2d9b25ad541280"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/f5/24/cb09efec5cc954f7f9b930bf8279447d24618bb6758d4f6adf2574c41780/typer-0.24.1.tar.gz"
    sha256 "e39b4732d65fbdcde189ae76cf7cd48aeae72919dea1fdfc16593be016256b45"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"khaos", shell_parameter_format: :typer)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/khaos --version")
    assert_match "Available Scenarios", shell_output("#{bin}/khaos list")
  end
end
