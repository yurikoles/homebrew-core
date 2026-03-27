class Jsongrep < Formula
  desc "Path query language over JSON documents"
  homepage "https://github.com/micahkepe/jsongrep"
  url "https://github.com/micahkepe/jsongrep/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2db5efbe33cdaba5b93d8a884baa12049b17174d839dce25480551a5fb358375"
  license "MIT"
  head "https://github.com/micahkepe/jsongrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e358bcbebe2789405403e465b06b6c31decebfd8eee13d232869d9de0cfb4d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37c37d1e14a4f885c1da5fdc8162f191346ce1d5ae530cba813423754aba639c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f88ae005e90595f5d6d497818c77706d27cfc00e07b24016437bc05885b435a"
    sha256 cellar: :any_skip_relocation, sonoma:        "99fa2ebc797b8cb22d63b2b2f28ce1b1e8634e2b5d9dec78cebb80d664669f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3444cf329271e28f2d5d9bfc71fa38e054e637ce8f58b9ba5ae337c49a40be58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "860b522358d10a57843349ae98513d1000d8b306a5465b3ea8c3e3fd7be0aea5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jg", "generate", "shell", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jg --version")

    assert_equal "2\n", pipe_output("#{bin}/jg -F bar", '{"foo":1, "bar":2}')
  end
end
