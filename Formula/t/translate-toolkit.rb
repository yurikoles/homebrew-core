class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/37/0b/5267a9814ed05495da25bf8b1786e6657eddb50a08a5c497942217cab76d/translate_toolkit-3.19.5.tar.gz"
  sha256 "ccd4af6b5a33d50ba77f231dcc488696581fdd750ec3edad42aa6fd640bdbe56"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fae436baebe485dd0ac7bc63c960fa7982e9b5a9669eedbf696b728b36166e09"
    sha256 cellar: :any,                 arm64_sequoia: "bed59f78f67071679673e9ae2194d0f7dbae864ee5686a5f2836f5b85d0fff5b"
    sha256 cellar: :any,                 arm64_sonoma:  "175ea4ea6bf6cf0870afc9755d489309a82d4450cd1f66dbd8e98b38c1cfab95"
    sha256 cellar: :any,                 sonoma:        "d8229a67dfd1bfb84b8aff48c1751d9285a703402e043144bb62ea8e079e4d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07d2785b6cda98c7e130f7114bb4bb68de4d2477adebc3320cd6a871b415ef30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc481ee0f45e4e5affb3ccaab3f0beb34b951aeb311e2eb234964cc87582c31"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ce/08/1217ca4043f55c3c92993b283a7dbfa456a2058d8b57bbb416cc96b6efff/lxml-6.0.4.tar.gz"
    sha256 "4137516be2a90775f99d8ef80ec0283f8d78b5d8bd4630ff20163b72e7e9abf2"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/15/cd/36adf321a9ba23906f44c1358164d6f69a149350c53802e366a270f7d82c/unicode_segmentation_rs-0.2.4.tar.gz"
    sha256 "d22f419787e77baeac966076d1bf09272cc1087bddfec14f74ce994437d3779d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
