class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.1.2.tgz"
  sha256 "abb1400eb41d6f9f200a6ff0bc92dc5b6e9fa60a12336ab4dd0cef48f8bb7e66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96ea657601d89dc72fc81f7bffc5f0d753f4ba660644562829824608fb15de1f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
