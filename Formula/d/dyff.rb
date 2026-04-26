class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://github.com/homeport/dyff/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "3edeb78b3166fc7ba4cdea1c9339eacbd57d768f27a77564adf58dc8819df75f"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a17206e3e18ed96c7af63d1af3b631cb67663ba3ad520da745cea17eba67c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a17206e3e18ed96c7af63d1af3b631cb67663ba3ad520da745cea17eba67c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a17206e3e18ed96c7af63d1af3b631cb67663ba3ad520da745cea17eba67c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "f811de5d3068cd55264f3b5d38e630b167cfd1e6926cbb91b9645c812d801a9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8597ec6d02415afd2df831cd22eaf26bb5246e2dcc5d34c2b51751e841206b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3cfc1b99d09802884f8216ad604332df88299fe3e820adb15ab33f2ab32d87"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/dyff/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dyff"

    generate_completions_from_executable(bin/"dyff", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dyff version")

    (testpath/"file1.yaml").write <<~YAML
      name: Alice
      age: 30
    YAML

    (testpath/"file2.yaml").write <<~YAML
      name: Alice
      age: 31
    YAML

    output = shell_output("#{bin}/dyff between file1.yaml file2.yaml")
    assert_match <<~EOS, output
      age
        ± value change
          - 30
          + 31
    EOS
  end
end
