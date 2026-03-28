class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "422ec08db0033b16b931fb1a75d3cab573a81314b7151e8ca81fff48463a6388"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7705bdee13f6e72215f4c22e72a995259b8b21872ea9331ffbdfaa2eaa20cb70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7705bdee13f6e72215f4c22e72a995259b8b21872ea9331ffbdfaa2eaa20cb70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7705bdee13f6e72215f4c22e72a995259b8b21872ea9331ffbdfaa2eaa20cb70"
    sha256 cellar: :any_skip_relocation, sonoma:        "cadf7a7e0fc873e02201a99ccf675f1343eafb1f59e151cf5db4f2a9ba065917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21d1967a988502f835aa6c89990459ce7853ec0c51215a8f260e539471b72fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a4d697a865c2ade9cb90ab527dbadbea6bb2558c5dca3719737f2b202e1b0fc"
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
