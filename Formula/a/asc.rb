class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.39.1.tar.gz"
  sha256 "8adfb009d74e84e0add5ac6b652f40c5022120fcf1221ee0c02fa5acec317f13"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "583295fe06fe14935f43ece84e80e12db5b43c97d3c865ee457357725594288b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bd7fa2779fae6c13ec7ef5f60527953c8a52abb2b20e0fe17c208107eb61f77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b045549c658b74cee26194b62bcaf68a2344740809db2f44808cf33ef8f7389"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b9262e81d91b44c6c4e37a053dabcb50904bd1e080f8c3394adf4e9d127cbb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea29c95b496a126e3cb3d230a15dcfdb1398a52eb6fe4269215f862731cd41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658e762ebb7ea71781f0efdfbf2c733bf47696bce56e4ae0e789f604a1de7828"
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
