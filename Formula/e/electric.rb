class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.3.4.tar.gz"
  sha256 "b9fcb08036d5067054ba9bb0581b99b672ec333ee470adf7e5c7a417adaa7bc5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cafa33ba0828674a9a8f48dab6d0dcf0d1921145f2b925e5891bb3788b529211"
    sha256 cellar: :any,                 arm64_sequoia: "fd78be517cf0097854dd59928b1ab72e481824e0ce4697f2e7c300f57d2b8dfd"
    sha256 cellar: :any,                 arm64_sonoma:  "ef3150f4cd190e123cb11132365f41eb58e756204cb4eaea5ffb8172fc999db2"
    sha256 cellar: :any,                 sonoma:        "839e71bd6e4a222e7044ae5aa7f55b428e310e284dceb99f1fcea483bb816acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7985bdd563f1e37540f227af001b37ef46f7be3ea7208fc34fedf7a016dd654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1047d9c7e6487e29c539164dc8859b545fb5873237b40ee071fa2000fc452f"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV["MIX_ENV"] = "prod"
    ENV["MIX_TARGET"] = "application"

    cd "packages/sync-service" do
      system "mix", "deps.get"
      system "mix", "compile"
      system "mix", "release"
      libexec.install Dir["_build/application_prod/rel/electric/*"]
      bin.write_exec_script libexec.glob("bin/*")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
      ENV["ELECTRIC_INSECURE"] = "true"
      ENV["ELECTRIC_PORT"] = free_port.to_s

      mkdir_p testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups"

      spawn bin/"electric", "start"
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
