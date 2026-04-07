class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "2f7f257b0e0068477893314079f18c82caf35e16f0f2562ba5f084cdb3968a4f"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d6f6e4bc9441fecc3ed7977e1ed68477c0557260a1e9f10609ae3930b970d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ef5aa513b52319a60342bd41a61958cfc99f3643c4094b4d47ae1b7c78fc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88408c3e34e6bdd596bd29263ea737c00285a064193b5463f1e9635df4ec4a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "619eda40b9fa7aa69bee2ab40c2ff7f05d6e925169e002e8a078c8c5b5795889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "317566de4e8903b0f5a13eefc5dafa138f5f4c339573887e4541c364f644e331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752cf52fdee81cf2aeaa0b8e583ce6900a9c842ac9522ba79c586583abedcb26"
  end

  depends_on "rust" => :build

  def install
    # Restore default features when frizbee supports stable Rust
    # Issue ref: https://github.com/skim-rs/skim/issues/905
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "cli")

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
