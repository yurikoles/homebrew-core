class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "ed97ee026e3f7119309de13a001423158b28823ec2636501b7141db165917223"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e8c94d5a3105c076fe11cebbd6081fa474a4c20945244f7b42e38a99ca5946c0"
    sha256 cellar: :any,                 arm64_sequoia: "03739e9ff0f4cd2612178a8432acac80d1103dc38bfedd90ae7501b85b3f9d2f"
    sha256 cellar: :any,                 arm64_sonoma:  "b97d83cc91d1e347a37d8a19e3f49aa6cb778d7ee5dba7d45bc4c727554c949d"
    sha256 cellar: :any,                 sonoma:        "79773f12fcccad62ee92780627965d595e38f86c71c2df99097858c863811723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29a28d417cd532589852901c99253f2f8d0a5b93c4cce94d530c20218520374b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81283023dba3b2a4dd9b20331f4fc7c518ded6cfb613bdf1a13d25fd7a8bcda5"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
