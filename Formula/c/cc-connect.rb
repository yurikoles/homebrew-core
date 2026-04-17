class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "0ae471e625966cc80b17b062c3013927861be4d4527d8d7d90bdbf5892d1bf51"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
    ]

    # Fix checksum mismatch: https://github.com/chenhg5/cc-connect/commit/92d4d81c205c346758170ac55bf17413fc47fd34
    # TODO: Remove on next release.
    inreplace "go.sum", "MEaUJLQJKFxTNo0xg+dKyOJA2Nu4O8kPVKuJ/gBiyjc=", "dRaEfpa2VI55EwlIW72hMRHdWouJeRF7TPYhI+AUQjk="
    system "go", "build", *std_go_args(ldflags:), "./cmd/cc-connect"

    pkgetc.install "config.example.toml" => "config.toml"
  end

  service do
    run opt_bin/"cc-connect"
    keep_alive true
    error_log_path var/"log/cc-connect.log"
    log_path var/"log/cc-connect.log"
  end

  test do
    assert_match "cc-connect #{version}", shell_output("#{bin}/cc-connect --version")

    (testpath/"config.toml").write <<~EOS
      [[projects]]
      name = "brew-project"

      [projects.agent]
      type = "claudecode"

      [projects.agent.options]
      work_dir = "#{testpath}"
      mode = "default"

      [[projects.platforms]]
      type = "discord"

      [projects.platforms.options]
      token = "MTk4NjIyNDgzNDcOTY3NDUxMg.G8vKqh.xxx..."
    EOS

    output = testpath/"output.txt"

    pid = spawn bin/"cc-connect", "--config", testpath/"config.toml", [:out, :err] => output.to_s
    sleep 1

    assert_match "failed to create agent", output.read
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
