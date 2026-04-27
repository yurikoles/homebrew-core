class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v19.0.3.tar.gz"
  sha256 "12a20d2c268520e8fe45fc5f933111d1414a79887a02f723e677c6270d6e4fdc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73616c995d3f384e8d10184238d6b3ad61b67dc69996a84178526e0198b6d574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73616c995d3f384e8d10184238d6b3ad61b67dc69996a84178526e0198b6d574"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73616c995d3f384e8d10184238d6b3ad61b67dc69996a84178526e0198b6d574"
    sha256 cellar: :any_skip_relocation, sonoma:        "73616c995d3f384e8d10184238d6b3ad61b67dc69996a84178526e0198b6d574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8a2a004b979cd69faa4cbd03a665851f33c19209fa1483fc0366a0bef65800d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a2a004b979cd69faa4cbd03a665851f33c19209fa1483fc0366a0bef65800d"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    rm ".bazelversion"

    extra_bazel_args = %w[
      -c opt
      --@protobuf//bazel/toolchains:prefer_prebuilt_protoc
      --enable_bzlmod
      --java_runtime_version=local_jdk
      --tool_java_runtime_version=local_jdk
      --repo_contents_cache=
    ]

    system "bazel", "build", *extra_bazel_args, "//cli:bazel-diff_deploy.jar"

    libexec.install "bazel-bin/cli/bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
