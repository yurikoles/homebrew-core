class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.451.tar.gz"
  sha256 "eef95b2d0d9b0c39e4c17900525b4beb75e15dd0149dbf8f2283be17f0eec043"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7b6b444ca6a7a94a5554468aeb5e413ef5e127e3c220692f5e13ee784647b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b7b6b444ca6a7a94a5554468aeb5e413ef5e127e3c220692f5e13ee784647b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7b6b444ca6a7a94a5554468aeb5e413ef5e127e3c220692f5e13ee784647b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d358f6a1ee319c9d4b4e6a46a7c8c3733a74a8f0859cdf6bb0c4117750a4ec7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f746111e75e39311cea9ebabd0694b41f90736df126e33f2b538149f18659882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5caf70076e53fef3e8da7bf19a5a748d6a1a8d50be06aac481733be823d8bc70"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
