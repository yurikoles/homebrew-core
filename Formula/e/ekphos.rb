class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.xyz"
  url "https://github.com/hanebox/ekphos/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b7ac48edd5b106e58048b1170192430942b23520e62720d20d0b729952f7c7fe"
  license "MIT"
  head "https://github.com/hanebox/ekphos.git", branch: "release"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end
