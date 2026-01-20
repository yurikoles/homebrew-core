class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "ef785dc99275190f0985ab33b24b7ff8f9681cb68f05c0e16a6d6a79b3f8fc39"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a473399c434e6653314e2f6c09acc62facf84ff0d1dd5bcad5c9d7e62806f0bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "694481c74d7ba3a5a8a636be9ee3897bf32c3e2d25decbed3d493cb69f3d6779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0336829af4b9d64563a956443473a2851038cc9bfbf4e1d177005e10009e481e"
    sha256 cellar: :any_skip_relocation, sonoma:        "252e510649d9f44d2cf63f40b6b054b968bcb67f2911ee99e8168287b48268da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "080b3d53768365b537c0ea502e8eab34424ea86ab309aabcc34115b3764bd59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "720c97baf858dc027265ccd0e6aebb0eecf3b8d3a752c57e981518917d358127"
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
