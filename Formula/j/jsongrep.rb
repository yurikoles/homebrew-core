class Jsongrep < Formula
  desc "Path query language over JSON documents"
  homepage "https://github.com/micahkepe/jsongrep"
  url "https://github.com/micahkepe/jsongrep/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "5c6d42f5a76e880242c42ffad2f078872d5bb7f4a9e98eb3e3bda92089a682b4"
  license "MIT"
  head "https://github.com/micahkepe/jsongrep.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80c76baf0eb0141905b0fbae46c721a535fe5d0061b62570d9180b8bd1464a0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb5a826acffc7e47e210e010b92b5db0bdf16dc3f5b98ea28ad2dc5754e68f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f0bfe95e6e0f7dab749c2f057f227cb9201b0fb211f5c4ebc849e38646c1a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bad192c143b156ab23a39d29879ab638f4d3afe309311e293336ff4c37a239ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f7186f420e913d6137da1e5a08a4824919a226cff9b0a69ae531cce7fe6ca9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30714c44b681f30e75a82a9a84d192e7ff5f7a2b386fa05363ae62e7edae5201"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"jg", "generate", "shell", shells: [:bash, :zsh, :fish, :pwsh])
    system bin/"jg", "generate", "man", "--output-dir", man1
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jg --version")

    assert_equal "2\n", pipe_output("#{bin}/jg -F bar", '{"foo":1, "bar":2}')
  end
end
