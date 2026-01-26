class Texttest < Formula
  include Language::Python::Virtualenv

  desc "Tool for text-based Approval Testing"
  homepage "https://www.texttest.org/"
  url "https://files.pythonhosted.org/packages/59/56/76dde8ff62bd8cf7025d3bd9dd2a021391b4aa8e449496c2aa2c5e0a75e7/texttest-4.4.6.tar.gz"
  sha256 "ddf2210f9b774f43702d1f3204e69ec908db642d10412a55cf5f6c3f72de1f8b"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66def708bd3edca475d00878e7a295156918753563a63e7bf8a6abbece577ab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "707f18abde6bd5a5b501d23152c9f55ba7cdaede653995d7a6365104ed6b18b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cd8caf904a5695bd3e7d80008f2640a8df183a3849a82d9448ea6b153646033"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c54892ff2a2092027639b777ee00852067dc36ed4c11f2c467426e94bbe5b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56731920709d9d0a9f293793fb0cefab826cee9bcedff9e45e012178dc0970f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a505872aa2656f941827bdc33e9c9b0a1b8edcee4c34033b11f42c79b2b178"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.14"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"testsuite.test").write <<~EOS
      Test1
    EOS

    (testpath/"config.test").write <<~EOS
      executable:/bin/echo
      filename_convention_scheme:standard
    EOS

    (testpath/"Test1/options.test").write <<~EOS
      Success!
    EOS

    (testpath/"Test1/stdout.test").write <<~EOS
      Success!
    EOS

    File.write(testpath/"Test1/stderr.test", "")

    output = shell_output("#{bin}/texttest -d #{testpath} -b -a test")
    assert_match "S: TEST test-case Test1 succeeded", output
  end
end
