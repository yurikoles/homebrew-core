class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.9.tar.gz"
  sha256 "5836b0156f7f57d8f41626bf2f0500ca274505ead9fe17f508ef3e7bc5e63a26"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dfa694dc0d6cb46fc6380f0ade6c306319d3cdf0a653f0d7b35e4d0c5c65893"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f49c532a163752919fb03ab7efcdae4139e8849db25a4ed0c27e51472d4db7d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c8e76419d7146ba4621d284fece8e2b289fbb29e161926a4dcd7124ee28219b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a59c71ee0e755b3ad8d864106af952953118bef7e94d7216135a2ad3d19a29c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227bb52bb796dd5383955abde0e89eeb861bde23e7eabc240e7d96feb1129209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1e763e57b613f79ff8564d7a1791cd8b2c7a0b3f0510c04495d6fdc73f8b664"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
