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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc0d92157d6c4bfdfa4a5caf462840e235e00f12a02d763e30a6c097d6fe21cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc0d92157d6c4bfdfa4a5caf462840e235e00f12a02d763e30a6c097d6fe21cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc0d92157d6c4bfdfa4a5caf462840e235e00f12a02d763e30a6c097d6fe21cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a66ba331f39f0993230dd04da9602fa192c4f9b146b215597cd7a888308c7af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b4b555b90d407e1e9e04fc96cb16c42d06f65fa23b9f461cc1ad6bfa5278806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "283214a3ed3b70d81af85f0e59a4fb9ffa41fa6c6eb517859a7761aee3bef70e"
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
