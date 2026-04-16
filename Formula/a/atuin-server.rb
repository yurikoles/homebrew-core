class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.15.1/source.tar.gz"
  sha256 "0ce665c5702e2e5a5ad09d2fa8f5c28eb899ebdb4b6e557ab1d0f23fcdcac0bf"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd9a62a758d8960c9962688fc2930468f4ee48280b2f66ec602f3ffd13d19087"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f595032889eb8584aa5425ea885243466857bf5ff5ee31d8753e2f9fa59fa236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e510845abb32fbee179da1082a87aa11fe1d84ccc89fe649bbc10911326924fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e9ee70a918b461b9f012bca2426e2629aa78ab03c96fd560a3868614a5df3f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11122b52b8da224ef0cb15c090b3d40e8717cd492e23f9ff1565ce0744e14bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5c72fd56b1387b09e9de13c0501a1865910b6f49cf79964043d95d105f34a2"
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
