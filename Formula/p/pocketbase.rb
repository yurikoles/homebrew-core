class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "cf69bb1664f4958bed1307608e4e803609905007256eed8e068b4e5a7a781377"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dda49baf6b0f76461146fcbd47545b6194a152f7f57b743e616a3bc5ffc36425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda49baf6b0f76461146fcbd47545b6194a152f7f57b743e616a3bc5ffc36425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda49baf6b0f76461146fcbd47545b6194a152f7f57b743e616a3bc5ffc36425"
    sha256 cellar: :any_skip_relocation, sonoma:        "25aac56912a5ea9284f5005aa0c2075a34d73ca44fd90fbac78d20a8d48f4cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f961f42e8fd98e4b0163675b9f742caeb2ecaf92189c6339bb28a519e6bd98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebb1f6bf2434f38f1b58a5420f95c1c5f1c731cca72e37257ed0029073874c2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    port = free_port
    PTY.spawn("#{bin}/pocketbase serve --dir #{testpath}/pb_data --http 127.0.0.1:#{port}") do |_, _, pid|
      sleep 5

      assert_match "API is healthy", shell_output("curl -s http://localhost:#{port}/api/health")

      assert_path_exists testpath/"pb_data", "pb_data directory should exist"
      assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

      assert_path_exists testpath/"pb_data/data.db", "pb_data/data.db should exist"
      assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

      assert_path_exists testpath/"pb_data/auxiliary.db", "pb_data/auxiliary.db should exist"
      assert_predicate testpath/"pb_data/auxiliary.db", :file?, "pb_data/auxiliary.db should be a file"
    ensure
      Process.kill "TERM", pid
    end
  end
end
