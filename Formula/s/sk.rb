class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "2cd53e11a9306f586a9f6c5f22153ff56879c24b0aefc2a325e6fcfb390d4c2a"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0299e34c36d0632d6f38f9dd0e58a7b7fd09c97fabeebd4f24f2129e8145b835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "226f4df8596393d80f555c5f0778f203ab704365ad68606a272a309533b93e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e166065d142c6fddba46bb869c76336582218504c4778d6a08f7c6c5f918ca9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "79b336b1f3e21a54ca34b31d79929645dc2171275982e56d91de9a3ff1617fc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e256f77484f928e10507800ae5b51d2e93f6005d02708e0f430f8a16d8827f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f3002ed0208275c1d9efd4e55d4be21f88629f047bb2827217a4671470d5efb"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", "--features", "cli", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
