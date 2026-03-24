class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.13.5/source.tar.gz"
  sha256 "a3d40446b43806461cd2e15d88cc0e6fe06cf6219de01db4db1c0f4de0150477"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e9dc5806383550c5d65dd02895fd9c28ac40b1d286306675244c0ef7125f71f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f47d62dec4893249031c80572bc9d621e87c23029bbdf429eed0eb922135af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c47fc117c2e72c46faa733e65f7df1b30e6b9e74ba2af65d00c44d82cd550e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b3025a7dacbf2ff119fb61f65c2c8c1c6772d5dcc84be191d9afef615af7a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2592adeb65a77b7924ac6212f0840550b5cb10703c5f5dbcbde40a19fc0feff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddfe9a8d47e29a3af3c6a7e14f593620542d4d5f045fe76725f05bc10a683f13"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  service do
    run [opt_bin/"atuin", "daemon"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
