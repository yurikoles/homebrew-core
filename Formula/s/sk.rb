class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "68740cef740de15a2165de5d8289b24d4fd1f4f26a2296478b70faadcb941cd6"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64554bfdfcf9fb352cee779baa379ab9fd2a8e1e018ce7a19e75fd64300853e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77e3a17f6a621a548831567ee8a5a283c0256c097551d544122dcc81c79c163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef8b8e4250720d7f6ee0b3427cbf3a709f084b0f56a4541220e80ce65bd22d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "955b506e260c273532ed1d4c6460ee04d3e025373cf3bafef40ce4369ac7a27c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aed7e10851af256afd76742b42c8d2ad8f58245c62f99e353b195f188272fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4922a7d4addeeca1eb4a3c99f3ea8af5d6b54f8cd741912d9ee8d58f68df6fa8"
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
