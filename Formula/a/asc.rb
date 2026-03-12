class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.41.0.tar.gz"
  sha256 "7388ae17c71674001b8bc6d4968971ab0941f80111579e19600a31d8070c66fa"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0b1d31e878fa536d2985b52eb202007bab3b761ebc93e322984eb7eacfb44b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ea475fa2a0736072d003bc9e0a9f1bde356deffbc2ae4a05aef5bad23ecf37d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7828e6681d014c1e686b51b3e849600737ca4dae69e7d828c362101404adb207"
    sha256 cellar: :any_skip_relocation, sonoma:        "22875b06b4d85ff4d56d282853e3b79b8192e73d04475300e1f1034f12f07fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "838516350c683dd5c3ddae881f38f31283d1971dc422ae8189de58943012b2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dca4dc0bc0fc046f2934297d6f169595af9a9581ed6af193c7a6bf6c958ff63"
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
