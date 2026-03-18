class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.14.3.tar.gz"
  sha256 "d07f81e0dc0aa08dae22db9de2ac38b76b13afad84e1beefaa91694178f4c153"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba19ab3d2525ea815dc700d4fa3f200dbb778cb9bfc87f3ccca2bea2c21bd847"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba19ab3d2525ea815dc700d4fa3f200dbb778cb9bfc87f3ccca2bea2c21bd847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba19ab3d2525ea815dc700d4fa3f200dbb778cb9bfc87f3ccca2bea2c21bd847"
    sha256 cellar: :any_skip_relocation, sonoma:        "e94f0286cb7c7b687802d6e8e2d953efc32f4696f160f60534612f6b9139b0e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fa89f5f99d3919a744ef627d6fc6a0b0a547af0bd55b9ecfab3fbcfa3e70f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eefeb3024d3ddc63bf62bc1f24f2f10339063cd80e7b6ec0670824eaca7f11d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
