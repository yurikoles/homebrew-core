class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.35.1.tar.gz"
  sha256 "36978817d552435627856632f4e1bfcdd13d218512f120f58f2e6c6a77fa0808"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16fc32cd9c3613b906fd323160d9ee28bfc9a4b090d5c9626144014e0af4ab37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c36adb30e6b9d7669a6835a3b6465c516c52d931422d42aeae35042f1787b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d13b6c8c749d7ee30f7cb6c07f34c7eef2118bc4f0101d2def5dd6fd052c2986"
    sha256 cellar: :any_skip_relocation, sonoma:        "440c5ff4e93ba880e0cdc8b1b3d963acac54f6e08f18ae14ef71a61344e382d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d64aa45e7b886b6546e7ea9c3ccd2dab5a3994b8d7ac88634808cc56f4509aa"
    sha256 cellar: :any,                 x86_64_linux:  "80db5450eb492292b1d1d77091407242301f0188bdfb29f332fd16058a52a8a9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
