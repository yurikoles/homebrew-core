class Bashunit < Formula
  desc "Simple testing library for bash scripts"
  homepage "https://bashunit.typeddevs.com"
  url "https://github.com/TypedDevs/bashunit/releases/download/0.34.0/bashunit"
  sha256 "dfb53a905b49fe791ac6b63b5cc2109287694346e4300b591ff11c0b08e7898f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "221a172df70ee5c01c94f0e2ac83e15fa4e6bff3835011c3f9e199039c88c981"
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
