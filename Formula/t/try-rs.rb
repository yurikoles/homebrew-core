class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "86f82d20fe7c309a87a17602425e6669f1ace622f50a545773c9596652af4a2a"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c29047b3e6e8d900bc68850d565b329a0992fd2054bb5ea33084bbc9b56d4214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3059c2f9932a1b40ee28613ad24e6f1065a588a7b190a8edef9891ae5d8f2ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a475b204596a6684cb949dc0d7510284402b90d56dc9c61c5134278ff7d293ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "967853e73b2bcc6e8f2711e68ea0810812c604dc2dfa2329bd7e6c60a2b906af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6dfb722b6f3da1f839fe8347d96a75b2843a7c69f351886f613d28fa71c92c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85cdacfb3188a33fa36c9eb81380b39b741941e242e2116f8c434f42fe38189c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
