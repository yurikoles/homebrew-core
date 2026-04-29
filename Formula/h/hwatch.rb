class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.4.2.tar.gz"
  sha256 "b13a492ac1fded05ee072c904f61f227a1a5119c6767c2dbed03eb2e7c261a1f"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c12c1ddeb7036b91b8b5324bd170b118440d69d7b98dd8972164658b3f0d7d36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1fa7b06b8d4625cac8cbebc19d22330c5b0da74fe7ea13edd55df49fc6cc0b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75d7e69a52d84766e1a6b94f49eef27a7bc6ffef2744a62cf1d9cdd164680e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf431605af79c2d1384cf1a416503477ddf54fee44e5a574760e4050ea347bfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01c3d1d2a1db6eafb02f1dbf31d42bb2b9714f6dd1d33134d182b61c7a678fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d176426960d4f5ed3193378f0e263a1d310829eda4ba05e838de34ebdcfbd9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    generate_completions_from_executable(bin/"hwatch", "--completion")
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end
