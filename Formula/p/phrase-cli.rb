class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.57.0.tar.gz"
  sha256 "d4da8754002b4c23bab5f967af45a2f7dc0f6ea1168f82e4593b021f913b8d49"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94819b666c1b65db2d01f8d8f266124ae8343e71154746417cef1aa20583556c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94819b666c1b65db2d01f8d8f266124ae8343e71154746417cef1aa20583556c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94819b666c1b65db2d01f8d8f266124ae8343e71154746417cef1aa20583556c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b6ffffc7eb6c01cc61a6a91c5be6f36c79d46a2b9edafb29a13e668a6662351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f43241cf65976311384440083b218411075ae7ef410e7b5d887eed31840b5844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "451f2067c916ad9d401c08987f2ef399e679123ddced74cf8231afa3ac72e4ed"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
