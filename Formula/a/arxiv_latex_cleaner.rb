class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/fa/0d/61cd8e7754424acae444e3b23bbcacf6487afffbf4aff17498b9d60c4e3f/arxiv_latex_cleaner-1.0.10.tar.gz"
  sha256 "cfe5f5c3ce2b69ea8a984eac61212e17b69f52aa0a5a7bb1cde51699eb50a7a3"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "0aa4f023567c96cb224e27b23bd7d7f46af7560a47160d9d0347ec8aeab665d7"
    sha256 cellar: :any,                 arm64_sequoia: "146b23e2785e71e5661febedb3faa0260b28c4ec16b6eaad2ee53b26918acdf6"
    sha256 cellar: :any,                 arm64_sonoma:  "8fbed795e668e2dd08b569908ee9ca4f183b6e730c802ebf541806665696e035"
    sha256 cellar: :any,                 sonoma:        "83da74885a44096ffe6ca4341ebe6e39d7622e6a283f8b12f0c7f4d95e34b113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "736e54216d418f80b50fc48130b57de5bc0654e2e009b6b5f82d979763de40c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540beff3135b2c24b7415f8750668aa3f9cd52e19f9bbd5b6148869351a35acc"
  end

  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pillow"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/64/c7/8de93764ad66968d19329a7e0c147a2bb3c7054c554d4a119111b8f9440f/absl_py-2.4.0.tar.gz"
    sha256 "8c6af82722b35cf71e0f4d1d47dcaebfff286e27110a99fc359349b247dfb5d4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8b/71/41455aa99a5a5ac1eaf311f5d8efd9ce6433c03ac1e0962de163350d0d97/regex-2026.2.28.tar.gz"
    sha256 "a729e47d418ea11d03469f321aaf67cdee8954cde3ff2cf8403ab87951ad10f2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~TEX
      % remove
      keep
    TEX
    system bin/"arxiv_latex_cleaner", latexdir
    assert_path_exists testpath/"latex_arXiv"
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
