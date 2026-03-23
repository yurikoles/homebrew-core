class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.63.1.tar.gz"
  sha256 "07bb49332ca2dbb995e43296a422d76b3f2473bf93003d00167cac9c4aed7807"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ba8aa8f12ca806c369c6443bb57e4298efaf8d88ac56f77eabc997ff9c8f900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb845c1312626a0b60ffeade3978aaba0f9fc956c18ea5802f882ebc391e453d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a891a24ada4711a7e2a18b1128dcbae7a093199201503422d684833308a6729"
    sha256 cellar: :any_skip_relocation, sonoma:        "1224c4d51f5b1814210220cdae40b6a1ba1573420a0e4b9ac6d8e467b5b0dad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "284c8aa3972c269087bd8d507eeec3cc176df181d18e37b3ef8b90a13ae5bb42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0ca4fa77cfdca7359ab284da4e9cecf3fa59bfa1c5b60126a34784a6d67081"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", shell_parameter_format: :cobra)
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~YAML
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    YAML

    output = <<~YAML
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
