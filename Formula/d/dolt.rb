class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.83.8.tar.gz"
  sha256 "aa90eeeb79cd899af3260a064efef51c3db4c28cc2f3514dca893a3424a5ac16"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67a3e598a62d4d887b5a77e49836a8a7bf3f1de8f58dc9c0b4682d604be5b0d7"
    sha256 cellar: :any,                 arm64_sequoia: "82f9a1f7d524b0e5999b18be4f0f8d2844e24ef7d0d71ade811d4e467d4aaf5a"
    sha256 cellar: :any,                 arm64_sonoma:  "5cc18e280fa4951b4c735119d28f258b36a509e1318cd459a4ae9e0bb8e3ddde"
    sha256 cellar: :any,                 sonoma:        "60965094b552832fb7e4f2034a06fd9c0a321da9a68185fa50b46814252c3bc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd8bc7e16dcb67f602ef2c8cbef6bc5e87f47afd83837c3344733ed9efa9b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "311a5b30d1517157b873ad48f7417cc0e65dffd78d8951dbff21f88850dc1ed9"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
    (etc/"dolt").mkpath
    touch etc/"dolt/config.yaml"
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
