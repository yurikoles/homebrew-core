class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.436.tar.gz"
  sha256 "be87367f41021c4a699248b1755732898ec2c5520e1f46cbf25aba24e1789828"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08103ea0c66e99bf1e8647c07f0ca3de253225e36822d455436d72a22b823f10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08103ea0c66e99bf1e8647c07f0ca3de253225e36822d455436d72a22b823f10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08103ea0c66e99bf1e8647c07f0ca3de253225e36822d455436d72a22b823f10"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b4764326c7cf2e35295faf3af388a3a6190dca2a4a2ac3a8d70941dc6f1d98c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df9a8a08a54109e2d57e229fc4f3ed9b3d2b581de78fb96ec862bef148c65159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f121f0f09c741e2753f96ccdc8316c0196cc2cf45351840c38936fc659a9f2d"
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
