class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f5/ee/b73c99daf598ae66a2d5d3ba6de7729d2152ab732dee7ccb8ab9446cc6d7/ty-0.0.22.tar.gz"
  sha256 "391fc4d3a543950341b750d7f4aa94866a73e7cdbf3e9e4e4e8cfc8b7bef4f10"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d19df8b8c4ea2b9ac514bed30ed8fb119eb30361bf120e3108f03b3bc8255b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b90bc51ba29d276738e671978bde23c63b502f03e143ce840325326d99e38dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5fc36cf0c060085464eb0be40366936ede5a249bf616ca64957c443547e1a48"
    sha256 cellar: :any_skip_relocation, sonoma:        "792b805b59c912a5b740f02f274f646811354cad14d28a859065fbf7ecd91701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f54ee19669a0314444a794afa90b1c738588256e347c41812877db203105da51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5544c8a1aa3f331eab681e3e520b4c4f0e42e1ed0549704c67044dd9adcb787b"
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
