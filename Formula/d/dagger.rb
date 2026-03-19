class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "368e71880b39f41cc1eb52fa44431b6b829c6176e5e890460b7cbb0e4712e67d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61f549351955a439949bccf8d2aea15f488866ddbe097af6951c5c3d98ef5581"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61f549351955a439949bccf8d2aea15f488866ddbe097af6951c5c3d98ef5581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61f549351955a439949bccf8d2aea15f488866ddbe097af6951c5c3d98ef5581"
    sha256 cellar: :any_skip_relocation, sonoma:        "7306742cbd1c217c519f1ae985a46fe3bb07471243d7536ca36ec3b95b33feb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a12c4db7800ffd13a5261987255be5971965bca3717a36297c0382105e4598f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac450a128e98783b372dd2323fcc6beac3210d33212c4db45883ad086aabcb07"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end
