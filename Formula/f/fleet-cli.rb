class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "4d34d07192a1fa2f73c8749118ce1e06bfeb0c3b9823e24d9aad467664c6f704"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a640511aa63fd1b2651088429f9a998b52d91cc680181187ed9fe3604b5d084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ed3f8d531fc0480ef47beea2245f5fcf51d91097357f0d10678cfc56f3da22a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b74df59cfed212af97aa6c166180b95df6804ae250e48b8653a97e08e21210"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1e9ad849e78b5832618ec246b389e95b7d217bf7859bf6eb121247510efdab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "022b26235b461334809ca91cb7f5b1d62a55373f219da1dcdf35066719474d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9672094ae1ee2eeb8d2713e583b411cc5ab7403b92115fb281bddc2ef493131b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", shell_parameter_format: :cobra)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
