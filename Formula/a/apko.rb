class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "df3e6e729b2ae98310434811a3fe1a1f54fd8f6e1021b34ee2b3c1df0324015f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf7f88157d73ab140d79919c413dbb4abc0e79fb43c6347e102b25dc9da9f3e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46dc8abcbf89572ece105bd982c73eb4e22a15845d1932cfdf9588069b53487f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "309ef4a070f973da71539b812cf06d7f327268965fb7ad762c40fd643b019ebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8942ce8c6968d5060bc8a6809d8375b0ff7c72f5347d3b79d1c87118117fc6ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5641d52995045e85654cb5416063ab7d00412b923169f915c57c29e129bbab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf020e8693e2390aefa134c0f679375676001205c80e8a67d64b6611f493c07"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - apk-tools

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end
