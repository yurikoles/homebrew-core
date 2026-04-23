class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.71.0.tar.gz"
  sha256 "c37a460efd3240180acbaf39fcb1b011be5f1d2866399b6359e62b6dadffaf56"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bb07642e49e3ba3390e42321cac3be3fa38c273febbee13a9d96791dd5bbf3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bb07642e49e3ba3390e42321cac3be3fa38c273febbee13a9d96791dd5bbf3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bb07642e49e3ba3390e42321cac3be3fa38c273febbee13a9d96791dd5bbf3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5c223587c715a2205c388fdc689f350b866ed2d478357f8a3a1786cacd497aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c49449fb918415f78d329c734bbee4ac7cd2e89a0964a424137ec9b950229972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a227fd3044c0aef489f394b1d418bab956c703f963250f4b6a88e943ac265dfb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
