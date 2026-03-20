class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.34.1/bashunit"
  sha256 "b620423b0fb201ff1c8d2c04735061cdea4237be84007348218a7e8d8522d8d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58b68b73762312da5a56ba26786e76da374fcbe6fe9e862e992e696c301bfe16"
  end

  def install
    bin.install "bashunit"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      function test_addition() {
        local result
        result="$((2 + 2))"

        assert_equals "4" "$result"
      }
    SHELL
    assert "addition", shell_output("#{bin}/bashunit test.sh")

    assert_match version.to_s, shell_output("#{bin}/bashunit --version")
  end
end
