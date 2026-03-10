class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "d58e2d0a4ed5e83e01d1a736b00d263d44ce7ac673504e2f1068f059d57a1e95"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "656dffe1f8b995dcd7445761aeffd8ff9ec6481a073044b69041db32c815a2b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "656dffe1f8b995dcd7445761aeffd8ff9ec6481a073044b69041db32c815a2b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "656dffe1f8b995dcd7445761aeffd8ff9ec6481a073044b69041db32c815a2b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb7aaed850922aa24cbbdb33045cbc584a34f514e8046ce091313e2df10c389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b1823dcd4471f349c18bb86c1035d769b2cf7827db350674a569e4898afcf8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3bb2bc51c7d341b52704b066bd36697471c9466d539fd167c09dde9cb35e745"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
