class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "7b35b6c14382ae1e26d92242373fbf3201bf0c6cb3df56f03ab3b99c14c20784"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "413f156a0732fb22fecca5321b9ad6e0975f5dcfffedfb4d550739a53ef6b56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c4ff793cbc49c76f4ded175b7c8d82b7e9492764de8bf869a1eb0c82f87442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67bf45fe11ba675e91cd2855833ee074c54b4f652344ea174b9218c4e3e5c75c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed7694a387beac509b1747d65d6347114294f7b5edaa5d1affbd61f3938cc14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59abbe175ad8e77431144a8beea7166913182be8e1d6d4d704a5e56e57822abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8023f9077ff272e0e4866b5e1928cdd184ac2a5d86c7dc672d2ad397a025484f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
