class Scilla < Formula
  desc "DNS, subdomain, port, directory enumeration tool"
  homepage "https://github.com/edoardottt/scilla"
  url "https://github.com/edoardottt/scilla/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "d3d767422c371bdbeda0f674f658b22b538c5dbc88ae4b449d8bfcb351b734d4"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/scilla.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f77581a0e63001d1f38c87d57f09ef186c95d0bbadfc6b6cdf31f12708d6b9ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f77581a0e63001d1f38c87d57f09ef186c95d0bbadfc6b6cdf31f12708d6b9ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f77581a0e63001d1f38c87d57f09ef186c95d0bbadfc6b6cdf31f12708d6b9ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "76fcea605faab109efe99cdfce6eda91dc0afd5680cb4e5cc362adabcce9dbce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "896627aa48caee970e920cdaac1d1e9f381aef84052987209e87120afb96502f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7cad92f1b1def9e4f2c0b74c7c096b2d9a43aabd4bc99d2e8005a8eca39d3b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/scilla"
  end

  test do
    output = shell_output("#{bin}/scilla dns -target brew.sh")
    assert_match <<~EOS, output
      =====================================================
      target: brew.sh
      ================ SCANNING DNS =======================
    EOS

    assert_match version.to_s, shell_output("#{bin}/scilla --help 2>&1", 1)
  end
end
