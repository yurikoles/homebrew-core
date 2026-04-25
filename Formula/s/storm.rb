class Storm < Formula
  include Language::Python::Shebang

  desc "Distributed realtime computation system to process data streams"
  homepage "https://storm.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=storm/apache-storm-2.8.7/apache-storm-2.8.7.tar.gz"
  mirror "https://archive.apache.org/dist/storm/apache-storm-2.8.7/apache-storm-2.8.7.tar.gz"
  sha256 "5a50b02c11e8a67baf8302cc3c9b5b099422fc0d0f076a67f657901748b8a741"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c312999d81da9ad6b66f6029ff436af69538c5a8f9887b94face955fb5280fd5"
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
