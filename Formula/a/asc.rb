class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.38.2.tar.gz"
  sha256 "1b476f9fcc06224463d08cc5a80523d2835267fa45761ff56cf316b462b5c8ac"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da1b93e82ed189814ce343a41c7aa0158f7a3ea5692fc35d8801402e444046dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2095581d0afb41c912750d59d8e3425739c20803dc2720120abb5b411d4a95a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5355dc56ef945cf11e16b2a2a2daefd6b5e10ba30c62e55b62e3454fa1f1f41e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b27d487ce8b3ec9ed35f31b2c4b90b16e360240bd4563c5bcfc9852e59eb6090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d1955ac2d917fdbaa523d0977de907aa21371bfed8e321f089f3754bdcce27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca21111a949ee5b07e1dec5dd7c87a4eb8ed7a5e0ba650d9894421283323795"
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
