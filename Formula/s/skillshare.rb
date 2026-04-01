class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "b192b239e8fcabd4e1f67c78e6574cc347a5e0f78e1836616afb01ef160376a7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c47709cb8b5d8ae889d3a1b45048b67e2a98b4a682b629daa547f2b741c5d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9c47709cb8b5d8ae889d3a1b45048b67e2a98b4a682b629daa547f2b741c5d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9c47709cb8b5d8ae889d3a1b45048b67e2a98b4a682b629daa547f2b741c5d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "679dfc361d9286a987303f7711ec8a7d73201da1ca96634abe79e18d0a1c82b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "297483498b606fe5fb57da65c977e7d69428ff4723bcb80540b6edc09c6e2a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f0d7eabbf2d2c46046eb15d90c8f42e9c46f9b5838452942fa459ec8a562760"
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
