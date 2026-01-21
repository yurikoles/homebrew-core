class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.35.1.tgz"
  sha256 "07971abf640fbc036b9cc67ba9b3353a37466adfc2215add3d8671b2f9f7001c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c479f4101e179704480388c9fcb79dedd4c08c95b4aed8f0194d9a191b7713d1"
    sha256                               arm64_sequoia: "c479f4101e179704480388c9fcb79dedd4c08c95b4aed8f0194d9a191b7713d1"
    sha256                               arm64_sonoma:  "c479f4101e179704480388c9fcb79dedd4c08c95b4aed8f0194d9a191b7713d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4bfae52a601f47f0b68cf833050dac7c4b66dc8f70dfdaa80724bfa24aadaa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dcdbe8793c86d5ebc6674165900dd035976b7cfb1ea8cf4efa59944b9beca8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26134606e99bf8db9ba16329f34f82aedb5ad9582cb549803ae266767c8ee207"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
