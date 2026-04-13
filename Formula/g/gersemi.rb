class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/60/74/349a9dd2d890787aba7ea00fa8c54f12f4b006cc84a37e6e9a02fc07684f/gersemi-0.27.0.tar.gz"
  sha256 "39fd89642c060d604a20330302721372be7b0987f0bfb53b2b2d2e96abd28bac"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0f3743f638ad6d348f3fbda16d34613a937bc306b9874c4d27622cafdc66eb3"
    sha256 cellar: :any,                 arm64_sequoia: "655563e0d45a4557e17395180284e19b1a099583232a7a96c9e511896abd4a2e"
    sha256 cellar: :any,                 arm64_sonoma:  "3a7f8f47b9bb8b5e83e3d6cc1ebb3c1e60cdbd1062543cf077167a8a598ff5ba"
    sha256 cellar: :any,                 sonoma:        "1817b84a41940dcddda9701131fa27e3ed8fdd0f57a671d7239eaeea4876717a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b035a27a4aa3b58e176b25a3670ebf1c8c8ba5f16ee55fb2e05fbe77babd160e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78bb1cdf573bab058a9c032e3401ffbe4bb19b038f7d137bb539712e180a1955"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/f4/4a/37928a560a345c6efb207452cf81d3c14f25a6d83df0fa5a00752c0c912b/ignore_python-0.3.3.tar.gz"
    sha256 "dc80ac80ace112da6d02f44681b6beb2ccecb68d6ac2b5e1b82d7f84347e1cf6"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    ENV["CARGO_VERSION"] = Formula["rust"].version.to_s
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gersemi --version")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    # Return 0 when there's nothing to reformat.
    # Return 1 when some files would be reformatted.
    system bin/"gersemi", "--check", testpath/"CMakeLists.txt"

    system bin/"gersemi", testpath/"CMakeLists.txt"

    expected_content = <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(TestProject)

      add_executable(test main.cpp)
    CMAKE

    assert_equal expected_content, (testpath/"CMakeLists.txt").read
  end
end
