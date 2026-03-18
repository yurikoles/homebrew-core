class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1257_SDK.zip"
  version "12.57"
  sha256 "15a0a22d3af08a62b7cd3903622d7eb8e6289fc66dd7e54fcd9e17330c95fcc2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e69a3adbf7e469cadf87352d39853a868c92a85bbc55ec136e1e9716bcb28774"
    sha256 cellar: :any,                 arm64_sequoia: "3d5510b2363871f82d8b6fd73275d28bff4ee841ef1c81072adffe3b583cb9f4"
    sha256 cellar: :any,                 arm64_sonoma:  "b0c967677149152e59d81967a21be816742d45bceec7e9c3b3bbd8ee2be6714f"
    sha256 cellar: :any,                 sonoma:        "615b624db4f09381765455c7a4a6cfe699530cf917299528ef53f4a6f57e889f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70fc1d6b2c8176037a3a4e18f02ca3083a5db75376ee893abd7b9d868448022c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e03ceb03b22eb37713fd49ae78eafd3896a94b74f4f81f1dfd019625a392dfdc"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end
