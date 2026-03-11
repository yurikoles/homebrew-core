class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.38.3.tar.gz"
  sha256 "e4f4f900d7319b5da58b6ccd79613c0ca15469679d9f7cadae928ccd570a5cfb"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba041d0716f37292be9f342f4f3b1caae70e15bfb3cf6a1325cad028d5d2ea4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a88a15df9261e5588d2f72fc99e14ce05ec7ff556b7281294901ba76eb35db14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8353276f04303b2f62fe672f2620b5fc9cac3cd6f77b2dc4948ba7ff8569c614"
    sha256 cellar: :any_skip_relocation, sonoma:        "3978bb504137e38eca3424d515416f903b3d185e76a2aa756eca5438d275d057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa383ec300d29bba06f836904d74dafc825e061e32289dfb94e2ea40c52fa1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8ad9d2f5f27c74476a0ce04bf4dbe58bdc7216e107f008440c49ce5d92fbfa1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
