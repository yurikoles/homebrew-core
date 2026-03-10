class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v6.0.0",
      revision: "ded52f56981ff736b6c9f9e7bda7a104902cca87"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a365116460d17da70d0920edbee70f10f6a5a30cb960c78bba09c2f6571e1a73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d627c909ba3e6bf83be2bdef56304db6462c4a7effc487abb407ab3aa8a542c"
    sha256 cellar: :any,                 arm64_sonoma:  "1a17379e3991e2880e136313297ed2e3fe8615fee8ea4e281a06a90a0bf272c3"
    sha256 cellar: :any,                 sonoma:        "4295825031d4cf7e040b28692cb4b6583dc3b8186effd952be498f5aaf9f31f2"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+

  on_sequoia :or_newer do
    depends_on xcode: ["26.0", :build]
  end

  on_sonoma :or_older do
    depends_on "swift" => :build
  end

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "homebrew/core/mas", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mas"
    system "swift", "package", "--disable-sandbox", "generate-manual"
    man1.install ".build/plugins/GenerateManual/outputs/mas/mas.1"
    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
