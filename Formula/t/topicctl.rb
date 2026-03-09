class Topicctl < Formula
  desc "Declarative Kafka topic management"
  homepage "https://github.com/segmentio/topicctl"
  url "https://github.com/segmentio/topicctl/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ac57bed1c6c387d050b8a7cd43c8b82457d7f34ac4bc4630ac8a6d989c8b0e69"
  license "MIT"
  head "https://github.com/segmentio/topicctl.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/topicctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/topicctl --version")

    (testpath/"cluster.yaml").write <<~YAML
      meta:
        name: test-cluster
        environment: test-env
        region: test-region

      spec:
        bootstrapAddrs:
          - bootstrap-addr:9092
        zkAddrs:
          - zk-addr:2181
        zkPrefix: /test-cluster-id
        zkLockPath: /topicctl/locks
    YAML

    (testpath/"topics").mkpath
    (testpath/"topics/topic-test.yaml").write <<~YAML
      meta:
        name: topic-test
        cluster: test-cluster
        environment: test-env
        region: test-region

      spec:
        partitions: 9
        replicationFactor: 2
        retentionMinutes: 100
        placement:
          strategy: in-rack
        settings:
          cleanup.policy: compact
    YAML

    system bin/"topicctl", "check", "--validate-only", testpath/"topics/topic-test.yaml"
  end
end
