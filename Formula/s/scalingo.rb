class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.44.1.tar.gz"
  sha256 "c9178d944a13159df2c16ebe79be14e4e2cfa48877a5d5e4a15986d3f6e5ad3a"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ffc9a5b60a01db89ddbc1128e3dd6e7a0f5b0e42e08994100fe20402eeb0b15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ffc9a5b60a01db89ddbc1128e3dd6e7a0f5b0e42e08994100fe20402eeb0b15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ffc9a5b60a01db89ddbc1128e3dd6e7a0f5b0e42e08994100fe20402eeb0b15"
    sha256 cellar: :any_skip_relocation, sonoma:        "25e4556d30719f84b198ce0e33953933340fbc507c1279a95126a9c9cc886652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3716b593810c611ce53020b4ad80cde964ff3a1a96e0105ad99c8a44549c3242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed2ff220083e9f7bf68bdb21abc42dbe0dd2ac73a060447b6ad502862c873365"
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
