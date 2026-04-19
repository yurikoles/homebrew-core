class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "15f989296cf70912bd3459fca1c0efc08e06c253935089d7d757ec28d2acbd39"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "335815de8c2820dccce21bdfa70ce4577c4d819dda28694e01c4833943746b83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335815de8c2820dccce21bdfa70ce4577c4d819dda28694e01c4833943746b83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "335815de8c2820dccce21bdfa70ce4577c4d819dda28694e01c4833943746b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceabe513ea9c37158864cfc5283bd5978cb846a349c71ea33aa6420555326440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8129f9a4e12049be5c3c7262718e2ee9fbe2244bbbf05bcaf2f0c59ea55e1354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "715b251a660b2eefb2b06785ccacbbd45d22d9470711cc903d0a21ac5952723a"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
