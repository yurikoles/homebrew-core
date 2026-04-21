class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/85/7e/2aa791c9ae7b8cd5024cd4122e92267f664ca954cea3def3211919fa3c1f/ty-0.0.32.tar.gz"
  sha256 "8743174c5f920f6700a4a0c9de140109189192ba16226884cd50095b43b8a45c"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15d308855d6d6e4529c123fb31cecd5635a9e56c59694f45f0f28bd58be108fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9114c19636a38ac828ebad58ffca40897fe931853b3f1bf6a595391aad559ff7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d516bf0fff49ab75723d2e231f2a3930df1c28cdd552b7fbd8898c488294e5db"
    sha256 cellar: :any_skip_relocation, sonoma:        "c98c899dd469387439b5425ab6702b15548d668e87907ad237643798918ca6a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4c7ebc8037b9b3c2859cb9a88d5a1559cb72b8a95fb1423e1fa5b340c3fed72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e49e819e701cb40a972bd5571842adc26693af9bd007f109af2caee3ab6bb86"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    # Not using `time` since SOURCE_DATE_EPOCH is set to 2006
    ENV["TY_COMMIT_DATE"] = Time.now.utc.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
