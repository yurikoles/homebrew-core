class ClaudeSquad < Formula
  desc "Manage multiple AI agents like Claude Code, Aider and Codex in your terminal"
  homepage "https://smtg-ai.github.io/claude-squad/"
  url "https://github.com/smtg-ai/claude-squad/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "e93da50a14e671b0177403a253c707fe96137f282a1bd01a470bb7b01ce7d5c8"
  license "AGPL-3.0-only"
  head "https://github.com/smtg-ai/claude-squad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c91b57567f1775130a2c84e6a6320ec64204695268e9f762f9017620d29a08c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91b57567f1775130a2c84e6a6320ec64204695268e9f762f9017620d29a08c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91b57567f1775130a2c84e6a6320ec64204695268e9f762f9017620d29a08c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "be2ed5b4b1b392bbbc6593defdef15b991896ca91459e52aa68b765687392387"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b4219e375b35dcf60822db199ffe0b091969d6bcd6dbecba66310a5d6c870a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8819ca1f84628e9be60d3a9d45b68690af27a34345cb4688038b520eaf738372"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"claude-squad", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output(bin/"claude-squad")
    assert_includes output, "claude-squad must be run from within a git repository"
  end
end
