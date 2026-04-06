class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "e693862cf4af9c6063e4b422e50d94cbabb3e4c464afa077f3205dc93872115d"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a67e59d107256969e6c75b440550eb39371b6273e926874c43ee55aa7e0ef86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a67e59d107256969e6c75b440550eb39371b6273e926874c43ee55aa7e0ef86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a67e59d107256969e6c75b440550eb39371b6273e926874c43ee55aa7e0ef86"
    sha256 cellar: :any_skip_relocation, sonoma:        "943e99d78daa6f04950b43b3f0109bc7b75d209da280a87280d893a44171ace0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "272f9c23e088ba070c60cb8625c42a7f477b24c9a169ce4ca58abd5f21484bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a9d168ffb5541170b752fd98c5930bf13e200c3cb8998bfae7345b72db4caa"
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
