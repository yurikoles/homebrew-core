class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/1.1.0.tar.gz"
  sha256 "f294915aa342af226a944479001bb6e5c89752b282ded9aaf1c306730fbf7b4d"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5610d62614595c49aba04e2273917293b5754c8be92fc4c3ae2c93f52ca0b88a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf9be56ccffa201767f10852d3ef5a8cab030fbda3d95bf1499bf8a59acea65b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "716d41445c177d04cc0b4de27890141ffe0486d83bdde9945441dd40e463b47b"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb5fd2e3db62f0a844bbbc87a3c1af00b5a5401b2f5bf76d5e03859e4877ae3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7b747d196b2e24b5ec1aa20c1395a1479d23e857a2f8023ca6a92a12ca77755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b69f06df7c16450731a7e46f7a5fe8836907a75c34721e5eae2440b14e03fbf"
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
