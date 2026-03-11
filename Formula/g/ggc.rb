class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.2.1.tar.gz"
  sha256 "36d3ceb5853a5985e3248e870d3c4ab4a5351777b3f03c2eeb5d994bf5dec62e"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d14a7c5d5d8a5dac2b69ed4852875e86cddfea0a8299692b8219fe161446c57d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14a7c5d5d8a5dac2b69ed4852875e86cddfea0a8299692b8219fe161446c57d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d14a7c5d5d8a5dac2b69ed4852875e86cddfea0a8299692b8219fe161446c57d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1341b78d406c9e040715eac1891966deda7ca1f84b9d033b5e17f95047ee1602"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ac08c1be8ddc92fcdcc9772a2410cf299a3819441c82b25c94015011432e223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b68e134a6e8ea91c465386c4879cb466a4c1e56e874e0b5aef14773768ec7f"
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
