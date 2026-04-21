class PocketId < Formula
  desc "Open-source identity provider for secure user authentication"
  homepage "https://pocket-id.org"
  url "https://github.com/pocket-id/pocket-id/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "9a8b59c49f10ed4a33c6b89d2505df7a7afbd3f0fa3d2f5ee5e376821c63c8d8"
  license "BSD-2-Clause"
  head "https://github.com/pocket-id/pocket-id.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c4331637e5996ffd67e548135ee8c2cd28e5909ea0e7584d0c6e2297b0359db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d142ed90e95435c8624ab3723b0b089513dc0d3cb00d9b0ea00f991e3f537d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1211adad18353bde333e509f00cb5d15413bdd886a400d3a4e8f1d7e2e978645"
    sha256 cellar: :any_skip_relocation, sonoma:        "707079c728b246de16f2d3972f59ed4ef7969ca044e32f0848d859b59f0844bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fe394cd8f062095081d8c2b6f683c340bb34f637324ffa7111df6b123d43968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab5e9545a91d11aba7cb80da6cb6de6796eec886d70acd84a0aba445c223d1bb"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    system "pnpm", "--dir", "frontend", "install", "--frozen-lockfile"
    system "pnpm", "--dir", "frontend", "run", "build"

    cd "backend/cmd" do
      system "go", "build", *std_go_args(output: bin/"pocket-id", ldflags: "-s -w")
    end

    (var/"pocket-id").mkpath
  end

  service do
    run [opt_bin/"pocket-id"]
    keep_alive true
    working_dir var/"pocket-id"
    log_path var/"log/pocket-id.log"
    error_log_path var/"log/pocket-id.log"
  end

  test do
    port = free_port
    (testpath/"test.db").write ""
    (testpath/".env").write <<~ENV
      APP_URL=http://localhost:#{port}
      ENCRYPTION_KEY=test-key-for-ci-123456789012345678901234
      DB_CONNECTION_STRING=#{testpath}/test.db
      PORT=#{port}
    ENV

    pid = spawn bin/"pocket-id"
    sleep 5

    system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/health"
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
