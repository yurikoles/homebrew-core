class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.49.0.tar.gz"
  sha256 "0c538896d0e60de5e9871c34c74753160548054d929c9e30134eb595a908ed82"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75a8b1ca413eb08fcdb53d5e69f163b722fa26955ae4b6ab172ba0f0b6306796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d459f3e2dfda4b8d0a0d989f77f4cee29e66187e8058f21ec026b0f7021045e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4a5856489390ba0b43e958689c2a3ddbd3337b71ba6a06a2e0ba3ced8eaab36"
    sha256 cellar: :any_skip_relocation, sonoma:        "b24d9374308c68c88e2671f1f115c83ca7fb0fd8511ef363f844df806303d27a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6bc2b80f781addf62db25f8bb69f471c045efaf8e6835819536404046a4e217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda4e2c9b232a1ee31e5e882dc13fb86904dcecb650bebc778e137785322a069"
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
