class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/4.0.tar.gz"
  sha256 "48799d929afb0b4d0b2bca57ce7919eebd5ff11227f49fd851adf20a1689113a"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c83a06eae0fbc270ddb34dd279062a1416ad1b9e19fb806946d24a8296e5fb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c83a06eae0fbc270ddb34dd279062a1416ad1b9e19fb806946d24a8296e5fb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c83a06eae0fbc270ddb34dd279062a1416ad1b9e19fb806946d24a8296e5fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2137b07aaee21bcc42ac1c292ee38dc1e4dc6c9edd4d100426adefc8467e76ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3444a94d4b08f460552b034a7b5e33f22083e10a18e7d9c9c9062e0a17d97f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "895b9bb9c58ac50967a72be03b5decf82db2449773ba79b525fa9d53450fce07"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w"), "./cmd/clx"
    man1.install "share/man/clx.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.json"
  end
end
