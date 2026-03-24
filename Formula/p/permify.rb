class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "90828985ba6a6331cc04e609f21ff476ae8b97f2787c7bb678b9d571b84a0a74"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77280e38674c8b158305911520cbd5510688f73d55ddbf3a70a662e75e4eddca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fcc4c4f6c7c9f5e28a4e64c0b04938754775cb4b5121f82dc64e3fc3b61a3a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b40cd11a252a1d5ea1241f281373179773f33b83ccdbbcddb8526b5992afe177"
    sha256 cellar: :any_skip_relocation, sonoma:        "672d1a746df2962b451b234c14fd20ac193574782ab67c9856dadc94be2268da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bff4d27857e9fc76f08971333612fdd0a9cf97ed4adfe25a13eb492523e7906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2e897be17dbefc5e5b5289eb16a947acfff8eb761aade19b3a37d9d674e02bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/permify"

    generate_completions_from_executable(bin/"permify", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/permify version")

    (testpath/"schema.yaml").write <<~YAML
      schema: >-
        entity user {}

        entity document {
          relation viewer @user
          action view = viewer
        }
    YAML

    output = shell_output("#{bin}/permify ast #{testpath}/schema.yaml")
    assert_equal "document", JSON.parse(output)["entityDefinitions"]["document"]["name"]
  end
end
