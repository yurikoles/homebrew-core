class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "153f800afa6b852f9c39c196f0655b98da631d2d5d7d60ecf512d5c845052f32"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f094760471bd674c34b061c72f432cd8cdfed9445949f978617847b7766a1554"
    sha256 cellar: :any,                 arm64_sequoia: "c51107d8092e750e4095d8c7a4dfb6bb331f894bc56a0b8d439ea8fb3c910d93"
    sha256 cellar: :any,                 arm64_sonoma:  "a65ed190515178eadc1679fe6b6caa8369a2c8421cb04fbaba963460d2948365"
    sha256 cellar: :any,                 sonoma:        "31ef6c2aa0860dd732942a33b90d846d2e75cd6b358fec515f434a1cca0c78f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19eaa923824da162a83de7dd7c25d96c273fcd35cb76b56f9f2e3adfe23cacb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089454996714b9d548d3674d5806f51020f265a77fc69d151e9080ecb2032dea"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"aoe", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".aoe/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]
  end
end
