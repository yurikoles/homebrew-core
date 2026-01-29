class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "8b8fd7e8a29b1f64f0990d353434eb2766165718d81de1515e87d9efbb9bac7d"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5de7249c7427af2a3dbe8ae468ddcd72fb9332d49a569850891dce510b4955e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9317d073d2849da4d2eb046e098db9233254c35379793af94916b8b8d07ff7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "536c153674967668805511ec58589b4728f0630d738ca8b2ad764aa2ef1ee47e"
    sha256 cellar: :any_skip_relocation, sonoma:        "79cc3ace730ad2c74e1141deabde441bcf8708ed7895425086e5b027fec368cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a238f78d7d58bb935e53440426d6dc65ecf0eb4f9d9339bd7a0c562f8bee4f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394ab9a8017c551066aecb3d63fcdc8e66f939afbcfae057478298de9c391fa0"
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
