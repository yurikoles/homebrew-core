class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.14.tar.gz"
  sha256 "a3c6fd68dd34386a2b8f2d789e959e7039dafeaeb4263d07fdfedc5f3b911061"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2a3f230e0143e94c236ac6bc897e0a8f71ef061f35a310470755ad188993eee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb79d1e029355b5af33ae618237c74f5d22cdd86dc0970518022d323e5c6e7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "438d823b8c776ce94a488648601bbfbe7b4d6d4ad3d0994da69a0fd784e3bf92"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dea2a6d7cef0c8c81bca622d874e9a347f990ae926b62960f10c1eb0e1d5835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b37a9bbf4b7b7d9ffdfe574dac490f006245aaeb080b15a54a14432d7f987f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66e6d7459a477df0de17fc1d8af69bf9966a493affd65f4e7329eb3fe8c66940"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
