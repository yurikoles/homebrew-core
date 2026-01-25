class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/refs/tags/4.4.7.tar.gz"
  sha256 "3cb9d8284f364ea6f4efee8506d8b10a9cbead37ca5413f32347d7ca95fbdf62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4a65ed68178c67f14e4365ad5d3955f2961c51c4b7f7b8cc9d3c620f726d000"
  end

  depends_on "fish"

  def install
    fish_function.install "functions/fisher.fish"
    fish_completion.install "completions/fisher.fish"
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "fisher install jethrokuan/z"
    assert_equal File.read(testpath/".config/fish/fish_plugins"), "jethrokuan/z\n"
  end
end
