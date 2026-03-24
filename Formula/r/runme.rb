class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/runmedev/runme/archive/refs/tags/v3.16.9.tar.gz"
  sha256 "5836b0156f7f57d8f41626bf2f0500ca274505ead9fe17f508ef3e7bc5e63a26"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "035bb780d2cc3133b1208391948b1baafc5cc5d9a73c88f8dc563666fc33281c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79c8d06ef897d74d60baf6ceccfdc875e0ad6ecb88a7bbf38a6a85ae20b34c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2612ac7882f0a09e589add037d1204552c1814e8a35f6da3410f9fe07d70847"
    sha256 cellar: :any_skip_relocation, sonoma:        "4703f2469047b59cec38efc7118f4255309fbec1aeee78b7e330399e79339c8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41cc103b2fcac44751aad52aaa6e2e94512d807ef04e3b55a83cb29779e2e387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a393d07cef01a8842fea002c79d08c736900b5359591db75d9b4be4c51089b8"
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
