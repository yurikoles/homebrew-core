class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "b954e00ad65cdbb015581a5c2c8c6903c471ba620bbf0c27f18f4bb36117d8f9"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9415ef9e141a654d7e58fb602bf70c4150eb8e61d8fd052a65fd0d3ad77010ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab07d4e04d6329fdbb8ecef65f57b1cde3016e1bcefef14f1efb099a735c2fc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50b9cd96aa6b0f0b87b24b90c973b44f36c546d7b9a3e0a8f22e71526996beb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbca9bde8ebc78c27b1e3e503552b65d0cf08770a8571f5b2dcc983082dd2089"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a758f854f2f2dfc110de3a74f3663f5ac959b760aff9ef7410771ae8bc68c387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81cd853c464f51218715e0feaf701840b615573245b46ba02ff9164fa09e47d5"
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
