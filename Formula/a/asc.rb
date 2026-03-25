class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.46.1.tar.gz"
  sha256 "7069ed0a3a791f6375ed11b0d9aebbfa4ab7ef8387b5de2e784d95abdce57e2e"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12daaf68e8a63dbd4d48f04a6e6c2198f35179f16b168a4d19b2aae717966316"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e393d45a3e48bcfefdda43ba67bac5ba6a4039c7cb26f156fc6ebe0a766bf75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "684cff6a40f77dd0471ba440b086e088dc748dc539c311845cd402a32cf93f6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "429de92c8b314af3b3d4daea57f2aadf8d27bdd9c67f8a90daaf4abf26105a15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9073b2938ec8cd4f1cd828396fddc30540465ceeb37c33dbc17bb71e09277e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc8000793e0db134d7bdc809117aab1fc44454de9657f907f878f47533aca8c1"
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
