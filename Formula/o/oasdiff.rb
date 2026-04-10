class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "03037825bc65df21b776c46a7eab1073bfe60c3571d6acc02f2bc516d66cd09e"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88d92d70e4005e0c94a78ff365115c419c28eee851d88dc2eb928798c367b349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88d92d70e4005e0c94a78ff365115c419c28eee851d88dc2eb928798c367b349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88d92d70e4005e0c94a78ff365115c419c28eee851d88dc2eb928798c367b349"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad537ce960df8bc9638d335afca62fe21a6103bc679cf6769bbaac1bd7f55966"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5447b475daf12ca9a2985695ff9c900fa218c5330a5868a900639fa298c6132f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559a96662679a25e197ab77efc2b8a0828bbe5d9ece2ea4275bffb3820adf385"
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
