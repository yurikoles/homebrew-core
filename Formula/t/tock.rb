class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "26cdedf4162ac82d21dd3e627dc1c5e5fd880e857727b2586719dd6006cfeb21"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13bb8161c219557c605521e1a83be9eda8e15416f1d15808c0bfd05342cbea6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75bf8207061c801d0d98a6a52d49eb564568d92c128b61c0b3a2e458a3dde642"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1ef200abfaa7a6107af8a9288842d8621e8ed728587c761785357f8df5503a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "81d119734a9d7d3be0a1cf2d98b3906b0ef9e87f84896b8733dd60d06cb14cce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b00379df86c042194a79d73975c1be261f7f768705fba6c0453bc8e40656c520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feb4d950f7da38036889e0fd7daf63a769318bbd763a991029581cccb3f67784"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/app/commands.version=#{version}
      -X github.com/kriuchkov/tock/internal/app/commands.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/app/commands.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
