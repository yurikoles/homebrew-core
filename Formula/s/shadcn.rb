class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.0.8.tgz"
  sha256 "f200e984256f15c4367babf1d26feb2f5aa373822f48cf1654c680533389c0aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c90bba7025172e4cbebb3c1b345ff552b8e35e192aa0f7980de7c9d41c06744"
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
