class Weave < Formula
  desc "Entity-level semantic merge driver for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/weave"
  url "https://github.com/Ataraxy-Labs/weave/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "304eeb0de1a719866fb757e4dc6333d5ad6f1b7a8e6ef2b2effac352632c8d33"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/weave.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ae7100484851a9d595d4b351244fcf189a9908c618f90b5275fc423569e4d2d"
    sha256 cellar: :any,                 arm64_sequoia: "9ff6516c1e2a1602b926e2474293f1cff5e50f9e7687e4b9ce9746fcd7600b97"
    sha256 cellar: :any,                 arm64_sonoma:  "a107c2daf43374df30048bdde2d585a5efb2ea2d27def0515d07df99857fca0e"
    sha256 cellar: :any,                 sonoma:        "a391db25766dd9bdd018abba1cd4ad2967dd35fe0ee6229599ad7413d8eeaf54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ceea7f8494ff1ba9e4dde011dee93654aff5de12d4ff40c2e08bd073d1221e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993ea39995778ad521a982d681008aa0517ce63b149ef6d13fdaddfd6da3a5a7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/weave-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/weave-driver")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/weave setup 2>&1")
    assert_match "weave", output.downcase
  end
end
