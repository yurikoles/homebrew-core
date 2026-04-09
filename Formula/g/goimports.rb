class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "1ed4d4122c215c978739d7b56bf701d3e9fd150d018a0a3a0fa114aa7c7cd8b5"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2062ada9f7476794877ac3308ee3ad18aee392f48ac46f1e442ec8c72be7b287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2062ada9f7476794877ac3308ee3ad18aee392f48ac46f1e442ec8c72be7b287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2062ada9f7476794877ac3308ee3ad18aee392f48ac46f1e442ec8c72be7b287"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b24df97aea3986e2d831620b38b7499e2df5468370729b7d89e3b78ed2d180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32bd37d9f72d189fd17292fdbdb6a1782173d36f394dcab2ee3764892ff25220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "798dec1541114684b25702769ff20f6824b1ccb6afa27c91af686c52f9b4c520"
  end

  depends_on "go"

  def install
    chdir "cmd/goimports" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        fmt.Println("hello")
      }
    GO

    assert_match(/\+import "fmt"/, shell_output("#{bin}/goimports -d #{testpath}/main.go"))
  end
end
