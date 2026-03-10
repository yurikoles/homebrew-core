class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.77.1.tar.gz"
  sha256 "9d5d0b076ab59bda6dcb528829b2f1ac6db55e009270aa9b800df98c2db4d559"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9e6b880049405af0a53c8ed239ba17cce4fc7273ef7cc78333beef2d6d1c5aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e6b880049405af0a53c8ed239ba17cce4fc7273ef7cc78333beef2d6d1c5aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9e6b880049405af0a53c8ed239ba17cce4fc7273ef7cc78333beef2d6d1c5aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1908a0b18f6e949e450d0d869aa39d98bd5506a2bdf4286f3146143ea2e56894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "600ee4af32710622e867dbcc5b70a7b64ccb2fa9372f6658c61efb67c27d47d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f3b5b3907300c3c80acc5b3c802cc3419f2d68b12627dfbf888e3d35096882"
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
