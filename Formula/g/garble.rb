class Garble < Formula
  desc "Obfuscate Go builds"
  homepage "https://github.com/burrowers/garble"
  url "https://github.com/burrowers/garble/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "78b418d98b1d24549bf660a50054263206c3eeccf6820438f10e8568b81a1bfc"
  license "BSD-3-Clause"
  head "https://github.com/burrowers/garble.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d9c85054c99c1bbb2e353caacca1954cf31cd6e2d6b2df029a61a6908ccc83c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d9c85054c99c1bbb2e353caacca1954cf31cd6e2d6b2df029a61a6908ccc83c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d9c85054c99c1bbb2e353caacca1954cf31cd6e2d6b2df029a61a6908ccc83c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a444269c41ed8b9701d9cc9339a84bb4ef67c72ef9b9fa3152acfb4e178ea63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39d254734cae250a41fa2ff10693b877f5dad0b0176e7fb5603224b9bc6dea7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4114023ed6dab4e1f09a70094ff97b8d8375ff1735794f4779aebf94928bedc7"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.go").write <<~GO
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    GO

    # `garble` breaks our git shim by clearing the environment.
    # Remove once git is no longer needed. See caveats:
    # https://github.com/burrowers/garble?tab=readme-ov-file#caveats
    ENV.remove "PATH", "#{HOMEBREW_SHIMS_PATH}/shared:"

    system bin/"garble", "-literals", "-tiny", "build", testpath/"hello.go"
    assert_equal "Hello World\n", shell_output("#{testpath}/hello")

    expected = <<~EOS
      Build settings:
            -buildmode exe
             -compiler gc
             -trimpath true
    EOS
    assert_match expected, shell_output("#{bin}/garble version")
  end
end
