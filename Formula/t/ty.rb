class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/19/c2/a60543fb172ac7adaa3ae43b8db1d0dcd70aa67df254b70bf42f852a24f6/ty-0.0.28.tar.gz"
  sha256 "1fbde7bc5d154d6f047b570d95665954fa83b75a0dce50d88cf081b40a27ea32"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3120eb4250816ec976a43a2eabc7512fa2767cd48bbb70974980b424eda74ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfc39fa57b19f18c7836f6d4d72209ae8068fc4c2b07a7dd8d3e0d540222a1b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc9d0438e0509dcf363dfcdf1b09a14ae9cc23ff3d5f5cb3c712e0c00ccbdb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "89457cb587e61cc63c09603cf6068da099133c75ca22facea187d2d56d5f8938"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4b888eeee5698749296c958db940086a8958fcba147966ac184d98b774c4f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a1f268c02b7400aa439519f13504705d1f7082454e0e86937953afd2eab2c3c"
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
