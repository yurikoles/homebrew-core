class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "fbcf87e7b6463d6273ac48693791c01d24e7c69360359175cc6e5c0fefdfb7b1"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "469e14a806c8bb07ea8332d6f22591e6a95162547e0fcda005fb0f50b30c1ffb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469e14a806c8bb07ea8332d6f22591e6a95162547e0fcda005fb0f50b30c1ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469e14a806c8bb07ea8332d6f22591e6a95162547e0fcda005fb0f50b30c1ffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "55352924a72305658bb1ad1b28096f24467e5fc7124255bb2ac8fbbe01ee49f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2576cb392bf8ba8834b4725b573b93f1b4945a7b46b7501721c5d7624b4ed63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bafa6a0ef552e8f4930859ed95b4cebb525ba195b04fa3726adeec6766dd25f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
