class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "a6dcfd64ffac51cd4bbdd592cec727c7fb0ebf82f80e2f4f3f65c6a7bbd8d21c"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a4e5907912d4abc204204fe4364dee40b105edb26e37bd307c5e852d34c526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11b3452c54a85770087a1fcbe15aea79bef0b7c77780bb9a97a6fb8ab677ba6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6551e8ed7858141a5df532ad35dd1578ab23249791b242abb318cb3fd39494d"
    sha256 cellar: :any_skip_relocation, sonoma:        "111c5d186122441184d3cf7aa71787054dbfa61a328981556dcfe00bb43c744b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50e13c083b2ca889f74513755fd14fbe2a1414bbdb7e6d957b947bfd2a6e0c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc7991e3dd983c85a4129eb68e990427bb94d48ae5dab652942a3ad0020ffdf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
