class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/cf/53/156600a9b55da259e419025fa8d08e7253b64e6af5923d53bf3bb6f41ca4/plutoprint-0.19.0.tar.gz"
  sha256 "55f3c6724f0dc217d28218ced1aacc23f7f87bf2b7e6682152eb9f80eb4e3d3c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7b632aa47bd4a198dd6fd316b68767d40113c19a6b6810f243924274f5038bb"
    sha256 cellar: :any,                 arm64_sequoia: "5abca63c70c3a035d53c0caf909dab8cd181bc3a0b9d4bc34458f7dd0e62e142"
    sha256 cellar: :any,                 arm64_sonoma:  "a80f46c4df4634a2fe62e7a7006584f138b6b47e681a4ebab7d918ed4e344088"
    sha256 cellar: :any,                 sonoma:        "45f4915afcbd6091acb02a9074bdc55968ff71862f94260dd5149e6938aaf1f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7556b1ddf6ea02ad6e3824d7f13f1188bd22109042ef892a6fac86e7bfb2d739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d7e133cd587bba0fe93fca8f5350496e10f5da9c6907e88629f187dd8a85b0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def python3
    "python3.14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plutoprint --version")

    (testpath/"test.html").write <<~HTML
      <h1>Hello World!</h1>
    HTML

    system bin/"plutoprint", "test.html", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
