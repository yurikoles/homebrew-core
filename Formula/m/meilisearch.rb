class Meilisearch < Formula
  desc "Ultra relevant, instant and typo-tolerant full-text search API"
  homepage "https://docs.meilisearch.com/"
  url "https://github.com/meilisearch/meilisearch/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "191fd8f5cee07489cd7ff0d8416cc319771fb7d473588842081bdc0c63fc5d87"
  license "MIT"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07462104121682cb12f47ab243b8b34aa502eaf2053a893f83aa664074dded98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c3334f47faaa2b01451e1969377109ccad693b3540944e7a5e5ae18b85678e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5272cd0ccb234a7009b51aab745ccb9c173e25f252adc59f9bea589a70e78902"
    sha256 cellar: :any_skip_relocation, sonoma:        "61fe1be100ffc5e36a78bd56b4d6a2a6be5347575a51b478af98eb333f13ae67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6897188fc0e11bfbea0d673e94f3fa4c2a682db2e912163acf53967a594fbd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f2c890a96c731fd2cf738b016bfd1aa8cfd2b1f8327f8827bce97a6416bbd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/meilisearch")
  end

  service do
    run [opt_bin/"meilisearch", "--db-path", "#{var}/meilisearch/data.ms"]
    keep_alive false
    working_dir var
    log_path var/"log/meilisearch.log"
    error_log_path var/"log/meilisearch.log"
  end

  test do
    port = free_port
    spawn bin/"meilisearch", "--http-addr", "127.0.0.1:#{port}"
    output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/version")
    assert_match version.to_s, output
  end
end
