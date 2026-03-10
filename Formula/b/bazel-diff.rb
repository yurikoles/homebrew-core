class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/17.1.5.tar.gz"
  sha256 "ff8c98497ffce4e3df564e8dc0bdc954bf8b242755f8c24f4d99b2fce756050f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09f19aa43f47f83bce4e80431c7b8970f7754d0d6f0982186c4e71d87f06efa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09f19aa43f47f83bce4e80431c7b8970f7754d0d6f0982186c4e71d87f06efa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09f19aa43f47f83bce4e80431c7b8970f7754d0d6f0982186c4e71d87f06efa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "71ac88d62941083661480fdb3f3e826b790adb818bdcd43309b2fbbd5c64b555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b17cddca35542104b4c7dc1908cbc83b49536659aeb389d6231221a9e726c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "921808545607c1e9a3babd40303c911fe15931596e4001fecfdd6c19af425f1d"
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
