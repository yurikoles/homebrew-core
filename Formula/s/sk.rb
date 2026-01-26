class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "16e04bf6960b83cc50d223fcc040319c43538a1aa44653cfa39b746275744c3a"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72320d7752f3ffc3c2bcedb2879b286fe006af9dd38190955af221f47e7f9384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a362184cf1c65d14fe0ea5da891fc3734ae4161a4d4c982f6361736444377452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2212dc2a9f01304880f84e8236e8841d01e813f44a7f10e4aabc54077bcf6b81"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb765b9891e26250975d197e1665c87e4c1bf5daf75cea67f0b1da37a50567e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f72276a7a3fcbf19963dd9e0e7982222410e2bb45b81565c4fbc67f4da0141dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c9f7e35979c590c7eab12ba8df87022defe42da438dac75d4387f71c7ca887"
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
