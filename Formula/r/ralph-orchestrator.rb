class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "658685fdf90ccf2d543dbaab0605dbd68ea9503317ae5ee95cb3cf0927947dcd"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6463026f93f5855ce9cafa44659cbe6a336b0ea3ab5513e4b7ff7f70f02bc3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "566de16f1a253d18c60e37a4e79fe2a6d48655c6354afc28ec1463c47fc219eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fd70ff335f453ff21ae7575eda254862b0792bdaad75e8499f40d7fba9642de"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d65db2f459babd9f9ffa45d8b246b37af70a5a9355d1b83e9dabdc1f4cf4122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75ae8c0692f3c6c37c35db2614b0be26e774ca0d720445846ddd7a7310fe9856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2a9a476d96cd35bc2e207e1e2440c577212dcddb4b2a3e7f64a0e841c35760"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end
