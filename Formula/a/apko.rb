class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "86c9753de277ee73b0db446407b28e31654f3da922e0ffb5b68d279e43d1364c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8c7496ee0256acc4ee53d3e7d8071a5a7307b01cbcecf44b7682a3f70891136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f5f8856216712d16f565f45ccd234984fdcdbee7eafd623d7fb308786cc73bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac16610ffea712647b4aece66d64a7d65c4382585b7f0644bf59cfc9bc011f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c5e4cea5082ca87fa56b471d05aa9e0bb22ed5c89212acef54c0c0deb75404"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c988f05b4a904a1ff0ceffbd69108e208d88c227ce5c42e00ed924de5996d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e9b909aa3d68c11ef8ba5536afe09c3d8ba543c8d3bd297c8b3a56becdebec"
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
