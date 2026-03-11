class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "c744ffbe966ea542beb4b234c2c2301e198440fa006434a7e38d3dd106ed38ab"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d0d0d328ebf34b4792d80ceffa1b682e12c6c1b546da8dc63539e0e659f91bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d0d0d328ebf34b4792d80ceffa1b682e12c6c1b546da8dc63539e0e659f91bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d0d0d328ebf34b4792d80ceffa1b682e12c6c1b546da8dc63539e0e659f91bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5457ce88edcfc5635ef289ad2d69fab00f74619d1aac5666b4b96f1bb5a22100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a22c05642bb23eb3108cec8526f65c574d78d7d212e38125cd792964897b038e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b39e5d39ffeb86a6b8e1cc602aa1080adb1c7fea01dbbb30b2a3c0e89dd39dd"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
