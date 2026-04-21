class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.78.tar.gz"
  sha256 "2e44bc3234387aba50222233bc25767e04f95d7a9c9f5708cd2e79fd20a18439"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ad9e051288eb70435ea4e148a85768c1f44a9a720c0d56730de9a59c743608a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "322d68cca590f51abc26a7c124b9975398dd13ffb41201e144bce1bfeeddc943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1d5271eb4caad5c2f5c4a7bedfc08e45544a1e7c3cacd9a334bba8ccfe64f51"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a7f62e510666b97d404bdac3b294e079023f728f9e3d228bbc474615668fec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91754e895a3fbca17392df4762e32a0e2b7d01e00989f1d983fdd5ea6ab0af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e42e6a1835b163d8ba625a81e5e8e564d051a781a1e8c5fb01c4ead4a1cee5c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
