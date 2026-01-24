class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v3.8.0",
      revision: "5276213d5babe4441466a1117d0037909b26d1c7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/influxdata/influxdb.git", branch: "main"

  # Upstream no longer creates releases for tags on GitHub, so we check the
  # version in the install script instead.
  livecheck do
    url "https://www.influxdata.com/d/install_influxdb3.sh"
    regex(/^INFLUXDB_VERSION=["']v?(\d+(?:\.\d+)+)["']$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "0b56eb69673cec96b6e0abc6fdeb5807f26971b63d9c9e59f243de2e6e0c4433"
    sha256 cellar: :any,                 arm64_sequoia: "814ba255caf27a6a28ba8501e5d3d1e2a8ae8bee4fe5d95e6de138986ed2c359"
    sha256 cellar: :any,                 arm64_sonoma:  "4417f00dcf3f9b1e8eb646a28d486c56220abcbee07699cef4a3fb38e4f5800a"
    sha256 cellar: :any,                 sonoma:        "ad174931eba64ae5aa550d28619ec1aaaa9b387cfe4496759f14e4ff89fca399"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb100914676a5753dda3192c49da245e2d598d0daa54f4231dbbeff201ed5469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a90708ec7969b861c54b072b5c1b4f8e2e3fe5fe39e8719ed55afca095316e0"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "python@3.14"

  uses_from_macos "bzip2"

  on_linux do
    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    python3 = which("python3.14")
    ENV["PYO3_PYTHON"] = python3
    ENV["PYTHON_SYS_EXECUTABLE"] = python3

    # Avoid upstream's default of Haswell and instead let superenv set this
    inreplace ".cargo/config.toml", '"-C", "target-cpu=haswell",', ""

    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux

    system "cargo", "install", *std_cargo_args(path: "influxdb3")
  end

  test do
    port = free_port
    host = "http://localhost:#{port}"
    pid = spawn bin/"influxdb3", "serve",
                          "--node-id", "node1",
                          "--object-store", "file",
                          "--data-dir", testpath/"influxdb_data",
                          "--http-bind", "0.0.0.0:#{port}"

    sleep 5
    sleep 5 if OS.mac? && Hardware::CPU.intel?

    curl_output = shell_output("curl --silent --head #{host}")
    assert_match "401 Unauthorized", curl_output
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
