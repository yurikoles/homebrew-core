class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "51b4ef7b037d10d3fc7e6c1fd864dd09a916ef072c570db727e00faa632ace8a"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9b9a31c3fabda3bba861c0c57dad9ade280b02f4515869350bd1d80565beab5"
    sha256 cellar: :any,                 arm64_sequoia: "4ee88938a4324b27a321ab66b90109455926bd80bc71c97bca3fc5aae7fed329"
    sha256 cellar: :any,                 arm64_sonoma:  "ee11c6fc59bf65b6da1aaa590a2f7871d33eba42c7ede5765078a8b446981099"
    sha256 cellar: :any,                 sonoma:        "6662722af1b36ac0078d1362390ee25cbbf0740e39ab1ac5ca7ac25d5e10a2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b9378fbb417cefe988d180465fa53cd54bbf8d945bb26c116ec2baa41e3501c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75968ac4a9a3b0ab983927bb478e116a105d22fb5307d2c8586dc1386633c08"
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
