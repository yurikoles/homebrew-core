class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.41.0.tgz"
  sha256 "e5b62360d1be671b5f80052512983534c661ef5e2e7a93efb69fb7991a5a6233"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "26d416b57cd9954c50c432ca4d3d60e422fcde4543f285c51bd004803a875ec1"
    sha256                               arm64_sequoia: "26d416b57cd9954c50c432ca4d3d60e422fcde4543f285c51bd004803a875ec1"
    sha256                               arm64_sonoma:  "26d416b57cd9954c50c432ca4d3d60e422fcde4543f285c51bd004803a875ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cda117db8952124270695f3454eb95f4da840877f352a51dbe565afa7fcdfb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b5827b66e3ede888dde4926951fc144b14b3fb9afa3ba9aba4e19f669a66dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e4349fd38117334d6144151a65beaa79fc047e0f87aff14cce5891822feb0ba"
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
