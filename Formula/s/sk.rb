class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "d3cf052118a556ce30a0add8d191b72e3ae589639031697c28522a17e54e0cdf"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0766d3374540b9dede78533e821de07cb1af782e350c6d49f05386fbbfbeabd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e1ff53b7a90f7a88413aa61696036f69e8713ca4096a0211afe8911201f40c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "426bdab94e3e199745f05eddc5e8c895c853363dff757fcd7a8506a4d70e4d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "8daf6f4fb06e166d8480bd99e5d8a10371094ae9e9f147c08fc394e0a8501277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b1042bef3c28ce634a5703f071dd3f9f0df45d57d476ae91d0dc6973ae4fe51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3958069a68b89d5811b3e166bf138dabf52193c6ff520c098b0cdb6e6c813119"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

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
