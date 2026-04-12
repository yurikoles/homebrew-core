class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=storm/apache-storm-2.8.6/apache-storm-2.8.6.tar.gz"
  mirror "https://archive.apache.org/dist/storm/apache-storm-2.8.6/apache-storm-2.8.6.tar.gz"
  sha256 "add012b1b28b191c985e59fb6e9848eef919be87fd62762728bec2e658ea018d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0f7cf833ea579e584e7faf1f7bc7b4f50e30c570481e444e9c67f0566915cae"
  end

  depends_on "openjdk"

  uses_from_macos "python"

  def install
    libexec.install Dir["*"]
    (bin/"storm").write_env_script libexec/"bin/storm", Language::Java.overridable_java_home_env
    rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec/"bin/storm.py"
  end

  test do
    system bin/"storm", "version"
  end
end
