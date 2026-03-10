class Snapcast < Formula
  desc "Synchronous multiroom audio player"
  homepage "https://github.com/snapcast/snapcast"
  url "https://github.com/snapcast/snapcast/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "cb75a71479bf52910bf5f47ae8120ec41c89459b0d77d7cd560e674e437ef050"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "645caa8ed11fc578ac65e91f85fafdba5b0d39f1f127e8232e94e94c1924fb48"
    sha256 cellar: :any,                 arm64_sequoia: "98bd7f18a7fe9d9e3ca15b574a5fbd7035df6ae35432772da37ee0da7e8fcd86"
    sha256 cellar: :any,                 arm64_sonoma:  "bf2d72adf4a6869b4e13a7cca9b3768c865ae03a097297c78a092319a75c7972"
    sha256 cellar: :any,                 sonoma:        "a365b2cd656103c268e2c88b742e5ba3a311d313b28213b10e86cc7c1346ab6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0c0174d7aeed8002be34138d445a2cebdbcc48e9898cc39857fc698b3b0b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac5b3447b3d7e1fd765fda683dde042994960aaaf190bf9a9dd5eb593f5304c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "openssl@3"
  depends_on "opus"

  uses_from_macos "expat"

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
    depends_on "pulseaudio"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    server_pid = spawn bin/"snapserver"
    sleep 2

    begin
      output_log = testpath/"output.log"
      client_pid = spawn bin/"snapclient", [:out, :err] => output_log.to_s
      sleep 10
      if OS.mac?
        assert_match version.to_s, output_log.read
      else
        # Needs Avahi (which also needs D-Bus system bus) which requires root
        assert_match "BrowseAvahi - Failed to create client", output_log.read
      end
    ensure
      Process.kill("SIGTERM", client_pid)
    end
  ensure
    Process.kill("SIGTERM", server_pid)
  end
end
