class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.15.1/source.tar.gz"
  sha256 "0ce665c5702e2e5a5ad09d2fa8f5c28eb899ebdb4b6e557ab1d0f23fcdcac0bf"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7624474868d203337557e3528ff90b09bfacc9ce8c0b604d2044d37c1a331bec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432b6898a285fc30e2fd087d7a1e7e49bbd4e3cc914facedba734561b8bf2b2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09badb1c5e5761f4bad2e64b4b09924b3c2fe22941769aa744e5826453e14de2"
    sha256 cellar: :any_skip_relocation, sonoma:        "467844e88c2d9aeb8a9d22af3b28839a830e0ae6b7e25486e488194de0fbf8f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa9dc38a79cd455a850e1c01fc2752bce15f22a21fde6da51bd039bfce7507b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8060b57699cb71723aeb9c926065f0092f3f3082be55c63150629b87c245dd82"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
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
