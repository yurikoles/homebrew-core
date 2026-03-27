class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.35.3.tar.gz"
  sha256 "e9d83ddcbf79738f05a21563b8cfe142aefe34f03455268cc5b0befdad479eeb"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b26eff55fddf45c6588134c564790dbce55d2e9920773a66e18e9cfb9b196cab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b26eff55fddf45c6588134c564790dbce55d2e9920773a66e18e9cfb9b196cab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b26eff55fddf45c6588134c564790dbce55d2e9920773a66e18e9cfb9b196cab"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a1b6f4e7711a02fe033b33a644ae4ee23e191448b4b58ab7e4afb43e9d9ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c2bf7a2632fd4a242cf6939aa95f510f32c5232cb7e5f893490ded12f077977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "346adef6a20dd1bdfe5b0db8be1e8b79727923e3dc76a6382360efb9efc70d19"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
