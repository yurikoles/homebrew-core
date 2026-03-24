class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v3.0.8/xmake-v3.0.8.tar.gz"
  sha256 "73da077440d1327e24bc74da2888c418e589dc28966e6e6b5bd6e889721b2d07"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d894528d5e21853788f313e1b1407dc7002a77c2e2455fb6dbd147dce5de595e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c554d24cc53498d0bc996a7ae8bba9e7a88c7406a6aeb78d37409a056cf06571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9e67df229b1bf5e4ac7a796cef5b9b6c98d5ff8e08631fb5a1fe14e77627aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "67f0ecef9ca9f8964a6424890accf62abc0402066870e8baac0f4796573fae4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dc3d3045dfe881b65508deff3fb014f8e0b7841da5ec13fb9e9b2028102a1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1bc14dea30e316f040d34f7118559773a4f82bea7e4c964188077dfe9279ce6"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
