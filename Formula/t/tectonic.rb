class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@0.16.6.tar.gz"
  sha256 "fb6dd2c3844df2682bcd8d768e3c8298f0704788d8fc15defe04c74c9e39ebac"
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
    sha256 cellar: :any,                 arm64_tahoe:   "c805c0f828bca46ac8e71be8daebf3e932a3925a743cdd07f0bccddd42f82c3e"
    sha256 cellar: :any,                 arm64_sequoia: "25477183f4c079b5ca33441e9aee381634b3c65631de04b1fa5d3d40deedbace"
    sha256 cellar: :any,                 arm64_sonoma:  "a0328709d3cf42360be97e9f55819726ff036f592138c13d43cb6433d41bc2d0"
    sha256 cellar: :any,                 sonoma:        "47d5106f94d0846875392ba2303a113c13bc9db7ac5dd280bd06a5414bf31464"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cad133becfd4addc9132d31a6ff982aa55ad33c9aefa53c89d78975da3962fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c2d4658d8147b58dfb3bbe0a03d10715192eb1b6fb16ad4b4bbccf63843fce"
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
