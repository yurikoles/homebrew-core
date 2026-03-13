class Gersemi < Formula
  include Language::Python::Virtualenv

  desc "Formatter to make your CMake code the real treasure"
  homepage "https://github.com/BlankSpruce/gersemi"
  url "https://files.pythonhosted.org/packages/cc/ea/d601c2caf8436ee8defc23297d8beb7999be8d34bb087802eb1c8202b9a5/gersemi-0.26.1.tar.gz"
  sha256 "10762fba8e9d867352b315407f9da85a8873eac3a46420e467a779fd8fe9b963"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b88f81997fcaa33113302a555bbe0612d5da1d3d29809256f29a17d52f18d646"
    sha256 cellar: :any,                 arm64_sequoia: "07d0ed4a3b990e298396d2ec55bb349e89f5a9b25613c645ff8b39c25ff7c868"
    sha256 cellar: :any,                 arm64_sonoma:  "df3d13dcd56d3a0319d499cb4d5b3af401f9bcd434f0fdf5775b44ed313e4800"
    sha256 cellar: :any,                 sonoma:        "61af484b8e69ef59706167487e2372de164688b9dfd8b6de0b0ffbcec393dd48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1326fba218b208705f43265d9f859e8b3416cbaeddd6c96310b8fcab57b4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5acf1dc13c89822a49571c3b83d4bfdbb6c455db124de3e4ed9348cf11b78944"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ignore-python" do
    url "https://files.pythonhosted.org/packages/f4/4a/37928a560a345c6efb207452cf81d3c14f25a6d83df0fa5a00752c0c912b/ignore_python-0.3.3.tar.gz"
    sha256 "dc80ac80ace112da6d02f44681b6beb2ccecb68d6ac2b5e1b82d7f84347e1cf6"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/da/34/28fff3ab31ccff1fd4f6c7c7b0ceb2b6968d8ea4950663eadcb5720591a0/lark-1.3.1.tar.gz"
    sha256 "b426a7a6d6d53189d318f2b6236ab5d6429eaf09259f1ca33eb716eed10d2905"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
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
