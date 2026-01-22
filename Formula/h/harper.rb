class Harper < Formula
  desc "Grammar Checker for Developers"
  homepage "https://github.com/Automattic/harper"
  url "https://github.com/Automattic/harper/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "61788da9f48269926f3f3dce6edc741489d39b3c16c25a346cf06084ca70f839"
  license "Apache-2.0"
  head "https://github.com/Automattic/harper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21d43cef7ea65557f145e830532324248f4383f6a27a8b953f2886048e4042dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3b3d5a33fc03b8ee500fdfd2d771a4d862e511c30284174e695aaa740d95296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "589cc1d9b1f743bb83b9aa2a9de69310c203acb32094780a800b9d5bd1381393"
    sha256 cellar: :any_skip_relocation, sonoma:        "31cc9a2f7204a8b9e15ab5be5d5f2d0e4d3223fbcdb5faa8eb801fea483aa051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb15632e8f5b17999ac5ef73ba341dfc920f34762b3a6da28fef5108bc576f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d72f2ff96787d87da725fb7e2bcc7749250b8c47f952b0c0b01506051aecdc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "harper-cli")
    system "cargo", "install", *std_cargo_args(path: "harper-ls")
  end

  test do
    # test harper-cli
    (testpath/"test.md").write <<~MARKDOWN
      # Hello Harper

      This is an example to ensure language detection works properly.
    MARKDOWN

    # Dialect in https://github.com/Automattic/harper/blob/833b212e8665567fa2912e6c07d7c83d394dd449/harper-core/src/word_metadata.rs#L357-L362
    lint_output = shell_output("#{bin}/harper-cli lint --dialect American test.md 2>&1", 1)
    assert_match "test.md: No lints found", lint_output

    output = shell_output("#{bin}/harper-cli parse test.md")
    assert_equal "HeadingStart", JSON.parse(output.lines.first)["kind"]["kind"]

    assert_match "\"iteration\"", shell_output("#{bin}/harper-cli words")

    # test harper-ls
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/harper-ls --stdio 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
