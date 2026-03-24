class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.13.5/source.tar.gz"
  sha256 "a3d40446b43806461cd2e15d88cc0e6fe06cf6219de01db4db1c0f4de0150477"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d51c8d547fffde971463a4e31e4fe4140d78346a95e1c41e9d73089edc21f670"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a089e91df6c6ed533c348358e542194d3db43c716c71d27bf2867745c73319"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9550dd5008f9b62882f20991a06e942a813cd12d185754123d92cfeb9089146e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aa1d0da18defdb0ad17dd042af858cf26e81df52560e27459d7b0f1de4ae37f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a1150bc8fee21eda2ca133d678eb63d6a72d81d3c5c318d42c0752ebed8731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e30dd6c457b9e7ad2a192facf63e3bca9a09c260b0c4093b6ad1093be7f06c"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin-server")
    pkgetc.install "crates/atuin-server/server.toml"
  end

  service do
    run [opt_bin/"atuin-server", "start"]
    environment_variables ATUIN_CONFIG_DIR: etc/"atuin-server"
    keep_alive true
    log_path var/"log/atuin-server.log"
    error_log_path var/"log/atuin-server.log"
  end

  def caveats
    <<~EOS
      The configuration file is located at:
        #{pkgetc}/server.toml
    EOS
  end

  test do
    assert_match "Atuin sync server", shell_output("#{bin}/atuin-server 2>&1", 2)
  end
end
