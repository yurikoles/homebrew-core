class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.8.10.tar.gz"
  sha256 "013c63a387f246a6ba13141a2e2fe884082fc69ff1818408dd85aa422ad35920"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "d9a5159d018df7dfbebcbb1a5cc64cb36375a8583c7279992280500f67c4e67c"
    sha256                               arm64_sequoia: "34f75d9e3e6b95558619f0ba6f556d0764c84bc7b4449bd098c4b9b903410bf2"
    sha256                               arm64_sonoma:  "fe3823f2344373dcb229d6ee6fde0e1eef57e72b41a5f08f9ba3f1e3eabbd624"
    sha256 cellar: :any_skip_relocation, sonoma:        "712ddc17b56874567b52c693eec2929294356cfb86b91813a310a631d15c83a8"
    sha256                               arm64_linux:   "c19cabd1fcb0591bdd047a2c611956576212bc0996dd91f36d146b37fff04f16"
    sha256                               x86_64_linux:  "0434924565566b952f7cbc70bf03112f8a3983c13143204b7ae201ef19edd63b"
  end

  depends_on xcode: :build
  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://github.com/skiptools/skip/archive/refs/tags/1.8.10.tar.gz"
    sha256 "c51040f483cff35b57b5a03526cdf9fd96f3f9cd9ef93a952ed85d8207aeb3e9"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "SkipRunner"
    bin.install ".build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end
