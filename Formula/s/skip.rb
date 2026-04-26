class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.8.11.tar.gz"
  sha256 "1b0e4445286aa2bf07057bb5b8756114b1339a7295319d05fa823506db1c23a2"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "79904e3c652549ef8bcd840986299c4a2a639876fa140a9f61b10d9e72c969ea"
    sha256                               arm64_sequoia: "88b42c2c97c0b7efdb2603d83bad0c341ccdf00035edac460e4f793420721ca9"
    sha256                               arm64_sonoma:  "7d115e71a98b7ea10f5aafcd7201eeea1577836239298e2a9acd8e55d723cf60"
    sha256 cellar: :any_skip_relocation, sonoma:        "02ea050c6b56237b26a27825ca6fff87275ae45f38a147ba05916d7498a9a0c0"
    sha256                               arm64_linux:   "c59af92d1e01db5701da6143e91deece7d16881b2e8bb0bd350996bf802f03ff"
    sha256                               x86_64_linux:  "8601035fa97deb4d7f4d90035c6e9a660b5c5f8931601228ac34e94dad5b4506"
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
    url "https://github.com/skiptools/skip/archive/refs/tags/1.8.11.tar.gz"
    sha256 "31cfec3e0cc6b41d3f029cbb6afedfe69526f50847993e00331b504b48af6543"

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
