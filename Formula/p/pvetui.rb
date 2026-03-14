class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "6c5f6d5c8721c6b5a11349539c95af778300d347cab533bf9a6272d9461ca977"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da804e03c8c78d15dba47da93828c4e8a99047b87c74309e5af559033dd024c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da804e03c8c78d15dba47da93828c4e8a99047b87c74309e5af559033dd024c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da804e03c8c78d15dba47da93828c4e8a99047b87c74309e5af559033dd024c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba087ada44ab865264570f119854f6b1c80c690cc443a4703937925730203239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0167b1c847b73c1208b895862a66ffa4dc87de90060980320cd41c779ee000b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "218f48a091654af692fad688b3f0ea46f3c7bbf0ec23caef6fb882b4102b7704"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
