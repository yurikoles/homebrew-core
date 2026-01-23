class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "56d9253eb31009fa6856b00d0bad2ef0023e2d007f9fe08131836a39c9601a0f"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29a73f68316ba373d709209eabf03d90805e68a8099837c72f5d530338ae462b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e3665e0299cb15b1266674f114c6bfbaac0da5958dac2137d2d4a680859903b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4fc5efdf8d2bebd70ca72363d3ca77f9a024ba4b159632ed3a3d5cd6dab05b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "07eabb0edc64ba4c1109d0b2e7360f1a75fafc646b138f099985823ffb689843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d1bf4d3860bcf1b4230e6b89eea0c40df9301120eedfce92af56af68b51edfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0aadde0eaf660769dbb2afbe6a545f7f402bb05405b6efd89b167b52eb12e9e"
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
