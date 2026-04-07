class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.7.tgz"
  sha256 "67112269fcc78e0cae4f9531660b3037290f25f631767628ff8bec64fa51fc08"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1256c57527de13bd92d99f5d915f963dd9867cd8b964674525c77523084a0afb"
    sha256 cellar: :any,                 arm64_sequoia: "a6b191189dd433fc2b1b7fbab314a05f3dcd4b55c7f46a7e7c0b6a2136beaef6"
    sha256 cellar: :any,                 arm64_sonoma:  "a6b191189dd433fc2b1b7fbab314a05f3dcd4b55c7f46a7e7c0b6a2136beaef6"
    sha256 cellar: :any,                 sonoma:        "baca2a4c12d9e76a530a5ee003f37b369501023832ca2a4e0eacd447764cd715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "426c4354c1d50fc5aa82a70b8114cb7553ef7ae7633f2acd0d4af73441e14855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40eaeb67c3b8d837b581c61d40176f258affe2c3d7fac4d5f693fe148eb8f9c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
