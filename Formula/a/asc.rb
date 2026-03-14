class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.42.0.tar.gz"
  sha256 "4b7d1aa39d318dc2e1b0a334164f09997172fed872bc776e4db5d03fe31d2462"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70007b4d6a101d99fcb634b21dbad6b90c1a9dec8fd539cf2da01f4f3db2bb49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5d10671a3d426d212319cc0076a0a4ccbd8d15668ae20c5c23cafb6d71dcbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9106c7fa9f384ab5f693d35556d317b8269e9061a1cab1fd2099458f912c318c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d3d8f1f27a887fea2a009c9f81be2e5cc50f6b00ae1dc8df97d52ddda1f7de8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a5da056b494a6656729067d508df66853cab25360c4ca9e495eecfbd9157b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb669b695fff9ab868487e0d7eee0335159b7555e5dadc5e4c82876c219422e"
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
