class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.0.3.tgz"
  sha256 "d0fa54e572438d2602ec83e332106c3ea8e5656f14afcd53d3cb66fae4dade70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26620f06b3b6a1e38539a8aad472f9bd1685ff18132dfbbc6e35877f9366f4e5"
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
