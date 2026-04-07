class Tea < Formula
  desc "Command-line tool to interact with Gitea servers"
  homepage "https://gitea.com/gitea/tea"
  url "https://gitea.com/gitea/tea/archive/v0.13.0.tar.gz"
  sha256 "c08f1ffd1318461a80bdee800a35515b07f0d305333af4e06e66b3a518d54f46"
  license "MIT"
  head "https://gitea.com/gitea/tea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7376dc092ab19b62b9efc4180904c74fcdb404cd9d1c879cb99c1a62282cbb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7376dc092ab19b62b9efc4180904c74fcdb404cd9d1c879cb99c1a62282cbb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7376dc092ab19b62b9efc4180904c74fcdb404cd9d1c879cb99c1a62282cbb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ad25c9a092d02073d04a3fa853159a62c3f1634f7cb5d2c0233585359acd03d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aac366338deed098866976f3cee65d34cb820b8f64cc05b32e52821e70593ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f5b764a982c9d59396929c34f9057d85b929a83e0058fcc7f817be12b3a9899"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"tea", "completion")
  end

  test do
    assert_match "no gitea login configured.", shell_output("#{bin}/tea pulls 2>&1", 1)
  end
end
