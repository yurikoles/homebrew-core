class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "26edf6f1861828452355d614349c0a2af49113b392d7cd52290ea7f180f6bfe5"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "60e192013ed526934d3fdb58db612bf26308abfb7efc513e44956cb1366c06fa"
    sha256 cellar: :any,                 arm64_sequoia: "f9b1360981f12b9d988396ad7b128fc9af3057f2d2a4616d056f7bdb45f527d1"
    sha256 cellar: :any,                 arm64_sonoma:  "13b174aaa1dfdccbe72cbe4b6d98f1add1e5f3b2bd05eac20f9d4c1beb6a6d30"
    sha256 cellar: :any,                 sonoma:        "6f9e15e46ac12238caf770c49e3eca848f1e278145947fe94e3247f699258859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97b1e70af1c56c66c10fea543323655d2b78dc671be4f57e2e5cedc7c486776c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7497316f97f73587bc97bfa6fa519368dd2d7a6df72dd538005696ceb2017637"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
    depends_on "pulseaudio"
  end

  def install
    if OS.mac?
      ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path
      args = %w[--no-default-features]
      features = %w[rodio_backend cursive/pancurses-backend share_clipboard]
    end
    system "cargo", "install", *args, *std_cargo_args(features:)
  end

  test do
    backend = OS.mac? ? "rodio" : "pulseaudio"
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match backend, shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    if OS.mac?
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "To login you need to perform OAuth2 authorization", stdout.read
    end
  end
end
