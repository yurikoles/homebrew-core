class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.11.0.tar.gz"
  sha256 "c5cb0690957d52a3fb0a0b6acd7003ff7f0ba895ef77c65f98a038959387ba38"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "865a7e258c6753904f50f7c55af7a068e252ceb75aee9d67f8e55b76899a792e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f258107a62776c5a8f1c1099ca43b5484a2a57ed9b9a2ae8dbd87b6bf4c055d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36d7f89604ac556ee61aee93d23860ce37b74d08fe23160466a04b1b3810f786"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f9d26c85afd3af6c6e00d58ce2644c5112832b125c9cf3833c1722f00108b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5aaf6d1b72dd7abae431ff1b32fb5b5efc0fbf741e2d3c5a040495a73ce723e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5134ce0f5bc5e3c7f858465565e38a59a0394a546893b0e26fb92d9eca7d23a6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
