class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https://www.parca.dev/"
  url "https://github.com/parca-dev/parca/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "8db291778d7ef1eed8d69fad6c640970cd5a2b901ecdbd8041f3dc0817d6991e"
  license "Apache-2.0"
  head "https://github.com/parca-dev/parca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "145db40463bfee22b901119aed62e55b4342edd4cdffd913fba630ed56273294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb77f3c422b9565a154c4137db5f3bee9b16819a57e73442fbefcc92f1d97fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43c752566c0925b105f039e9c8662beaf3b76519d62d761f91d495197d6cccf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b65d914d447ac64d70cc756b992b32856845ae72fb78598cca26f0b51f6edba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ead8cf9c6ac99816525079145f126228ee949ca6d226667d9b7f47d59246a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "117b281cfed284ebcbec777f97fef9c1f7567ee22133eecdeae4f53f95120ec2"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/parca"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parca --version")

    # server config, https://raw.githubusercontent.com/parca-dev/parca/cbfa19e032ee51fccd6ca9a5842129faeb27c106/parca.yaml
    (testpath/"parca.yaml").write <<~YAML
      object_storage:
        bucket:
          type: "FILESYSTEM"
          config:
            directory: "./data"
    YAML

    output_log = testpath/"output.log"
    pid = spawn bin/"parca", "--config-path=parca.yaml", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "starting server", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
