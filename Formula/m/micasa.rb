class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "c2dfd5915e600223548a4757a17d07defca319fbd549709314e66d6ba673acfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ace7f45146dd80fc73b54497ac356cc8dbe9cce2a424a00d039dae18b09531d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ace7f45146dd80fc73b54497ac356cc8dbe9cce2a424a00d039dae18b09531d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ace7f45146dd80fc73b54497ac356cc8dbe9cce2a424a00d039dae18b09531d"
    sha256 cellar: :any_skip_relocation, sonoma:        "40fb01e18074e90e94a81562fb444f6a6f98581d5a4c9c59a987de214f2b8133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc3044ae9c2a957c6241b2349738de83b3e5cb096a9776bee301c0741842d0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6cf12cb53b7a3e0e531920d1e18b48cb5d6717f7c69e9419acdb0920bf3fee5"
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
