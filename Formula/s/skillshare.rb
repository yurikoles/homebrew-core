class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "e8642679a987ff6483ff600cfbf1d7d52b2975527f242f0052ef756f59af0306"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfc4f41b8dfc18212a3bc63550185c54888f8c1b2e6d1bcbd3d1a69c696ced0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfc4f41b8dfc18212a3bc63550185c54888f8c1b2e6d1bcbd3d1a69c696ced0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfc4f41b8dfc18212a3bc63550185c54888f8c1b2e6d1bcbd3d1a69c696ced0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5786bcf427d1a0b4766d7ec12b913edb6ea7db496a110ecd21b4a5788bd77c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90236a286bca2572701bb6ec89da8c711dd9b75f6a536601af2e94b1243df860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "514e1c99ff75dfacc8da220d2d575da6dceaa79496ec93c8e468bb4981c359f0"
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
