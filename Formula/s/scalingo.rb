class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.44.0.tar.gz"
  sha256 "100b8ad78ee00699be28715454a058d5c3a731112dd622b28d1c884091395f86"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ede9e78d28988316269f81dc81b5a95fe075489ede838e4dd90fd8180baa7e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ede9e78d28988316269f81dc81b5a95fe075489ede838e4dd90fd8180baa7e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ede9e78d28988316269f81dc81b5a95fe075489ede838e4dd90fd8180baa7e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "87157b18caf471d78de28bb20cf21510a210ed604ae49e0b54761635bcd84a9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad4511b9269f728ae7de96c000f57bb674a55c1e42266369d84e93cbb068af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b345871e08309192d7daa52b8f51a64ae4108f18f8862c4a812ecf03572747"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
