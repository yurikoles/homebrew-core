class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "3e8765b849996d073cc8e9a3bbd7d7575a49c041f01c9a8ae13725fc951142bc"
  license "Apache-2.0"
  head "https://github.com/buchgr/bazel-remote.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2938e4a481635cdd39a709bea02ae00526d5a787f650e8f48580f7dd54d6680d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f178f73163a7e5ce8c6e9e62d2d908d0a7c625f1e328503bd3b5aad8fe323145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ae768b03b5831ff2354090c2b35868184f7d6ae1f979e9a29c138697b12c66"
    sha256 cellar: :any_skip_relocation, sonoma:        "5146c3be66190b6c9261402cd452e5b76599a4c585d279eb287ae762035ccdf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6130ae2d7c9df9b569c8ec35f5348ddb9386723a4c203872ce3f2ee3fdb4d0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0fcc2d87fe990f1c6cc2385e2f10a08a9e16580282782ea0fcde57725284680"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitCommit=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["BAZEL_REMOTE_DIR"] = "test"
    ENV["BAZEL_REMOTE_MAX_SIZE"] = "10"

    begin
      pid = spawn bin/"bazel-remote"
      sleep 2
      assert_path_exists testpath/"test", "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
