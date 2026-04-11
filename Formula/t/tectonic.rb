class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.16.8.tar.gz"
  sha256 "7ca10b83b9c48f9b0907db32bb04b44cf778599c23bd2a45836bd39e27630535"
  license "MIT"
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59f345c86df6119b84d40b2e1ba0644a0ac6f53c4421eff978ad2afa67d31701"
    sha256 cellar: :any,                 arm64_sequoia: "ebc34056a7f388d7551120f1ae9160fd607f606daa1a2f0ef6b9185f3e916dae"
    sha256 cellar: :any,                 arm64_sonoma:  "7eded054aacdda2f440792a078df3ab7de5fe502087030812b2d31f522c676d7"
    sha256 cellar: :any,                 sonoma:        "e046c31663c18cf64da5723561a7436fa4d10515b6d84863c977929636ad9799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac58d93c44c78a90c947b7f92c032bf60fde2cfb4817b19a137fd83139a0215e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94976092624cca4be95453e9ee3fc664db1685cd3cae2b822a8e609d3e29b236"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "libpng"
  depends_on "openssl@3"

  on_linux do
    depends_on "fontconfig"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac? # needed for CLT-only builds

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args(features: "external-harfbuzz")
    bin.install_symlink bin/"tectonic" => "nextonic"
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_path_exists testpath/"test.pdf", "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")

    system bin/"nextonic", "new", "."
    system bin/"nextonic", "build"
    assert_path_exists testpath/"build/default/default.pdf", "Failed to create default.pdf"
  end
end
