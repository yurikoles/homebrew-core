class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "74424a0bc02f6399f43af99ff6edf34c925c004bb089667db33deefee37b7662"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5b199fa2f28c53bd6e2739e7132969dd599562d900021e6813e9bfdbfc40543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b199fa2f28c53bd6e2739e7132969dd599562d900021e6813e9bfdbfc40543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5b199fa2f28c53bd6e2739e7132969dd599562d900021e6813e9bfdbfc40543"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ce4839bd237973bff4e06fc0235efa3965f378de36380d5c0fe73e0e838a893"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970209e7fbf6fd65fc4df4ca06ccbeb5c2e6282a5b1f6a096b69e7a0a5d0a8cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcdf85c51a67d9527ce15ab1a6f38f6161dfa7020b2ac5a006bb34de7e964ff7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", shell_parameter_format: :cobra)
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end
