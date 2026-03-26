class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "1180b7eefd5a93c842e052a850d80c4487426d6ecd6d859401fc2177ff2deaf6"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "203576f867d92baf1773944ae3b8eb88c91349777d5c722d6a078b153243e4be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "203576f867d92baf1773944ae3b8eb88c91349777d5c722d6a078b153243e4be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203576f867d92baf1773944ae3b8eb88c91349777d5c722d6a078b153243e4be"
    sha256 cellar: :any_skip_relocation, sonoma:        "73817fe627af5f635c12baf3c8ad7be3d5cd98502316764588659d08e8e8f188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c87fa5735eef69b76538865426fab072b8e667cf29473e51f52befc4c3c627ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef4c140490c66c6ace4c6b89b317a8b7effc90e0f55ead9f4ea87c6cf6e3ed16"
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
