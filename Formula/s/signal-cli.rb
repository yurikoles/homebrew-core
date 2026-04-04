class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "b9df4f8be106e7ee69902fc4eb944b87c5c3117fe5bcd2306246130d86749dbf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7cfcca5f4603ddf90052025005484acab71531d75c0399d2961c07af299b0ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b457d14f6a981139d62dd2f989c6e7a6f54063de4b6c9dbcee2cebcca45383a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acb0af93a75940b06a71f1fe526e2ea4f22598d5a7c99a4ea17afbc0a914b8fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5af4c98f66c70ab954546061dab8f8729fb5a52073017a4a681a288083d36fba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "846d5383b5fd4d9e3ac877f9800716359a81288aee9d3ae58324af112168b6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d7af34ac93584d83e27dce3fe4f139f3a35e4661e14ba8b23edec683f458db"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  resource "libsignal-client" do
    url "https://github.com/signalapp/libsignal/archive/refs/tags/v0.90.0.tar.gz"
    sha256 "8b09956cbd6a58a1aafe96e5681b4d49c59c1c2ee03839d9b5ad25d5f347f520"

    livecheck do
      url "https://raw.githubusercontent.com/AsamK/signal-cli/refs/tags/v#{LATEST_VERSION}/libsignal-version"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end

  def install
    java_version = "25"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal
    resource("libsignal-client").stage do |r|
      libsignal_version = (buildpath/"libsignal-version").read.strip
      odie "libsignal-client needs to be updated to #{libsignal_version}!" if r.version != libsignal_version
      system "gradle", "--no-daemon", "--project-dir=java", "-PskipAndroid", ":client:jar"
      buildpath.install Pathname.glob("java/client/build/libs/libsignal-client-*.jar")
    end

    libsignal_client_jar = buildpath.glob("libsignal-client-*.jar").first
    system "gradle", "--no-daemon", "-Plibsignal_client_path=#{libsignal_client_jar}", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env(java_version)
  end

  test do
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    begin
      io = IO.popen("#{bin}/signal-cli link", err: [:child, :out])
      sleep 24
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "sgnl://linkdevice?uuid=", io.read
  end
end
