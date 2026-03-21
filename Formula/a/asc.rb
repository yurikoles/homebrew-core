class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.45.0.tar.gz"
  sha256 "fede47bbd0c55eb0de54c5af860c525b48ca161f18891320a09ffd0f5bed86b8"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bd0f34f432189a09b9f602ec7ab644694d18b2c956ece4f390372746637f163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b3559989e6e0fc2d7c897af98095524a66ac83aedfa1a66e09c544b848770a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f85c3a7c1b8f6965b1ed1a0b8f058c22c17146d52959753fc1e4e9de82009ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e6c4c00006bc37c154c244cc1880b54fb3366221e09eb6b32b99919cc23cd7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5f45fa8c2bd069d6ea46832b3ff99c9aae0b7b02b4157a85ce08b9edad8283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83970a4e2e5a8582887097904af09fc43f7f834065fc75fa96ae16c333035e6a"
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
