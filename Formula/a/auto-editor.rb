class AutoEditor < Formula
  desc "Effort free video editing!"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/30.1.4.tar.gz"
  sha256 "8acc28560d16fa21692ae19eaefd385cb8bc4ed5dbeb25f76555d75637f844d7"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "86369a0ff13e5f7aeb427f2af47ab415022d7c4ba6036cf99ddd5b4fcd14a6d3"
    sha256 cellar: :any,                 arm64_sequoia: "74c519e47e284e1459a1224dd92857b12894fc9ab15361094adf99ff26068c0a"
    sha256 cellar: :any,                 arm64_sonoma:  "59072d0be636b1c6e0674d760e744b7818625098ca91e138bb0e0355b5ad26cd"
    sha256 cellar: :any,                 sonoma:        "a774ecd5c55dbc5bfc233dc53172fa94b6fba927da2aefb231c6c3c6817123d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65305270234d7abc13d554ce75f5a3c34902e9c3d5437d546e8d6337edabe0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75148d63c73cee733b22abae750fbfdfa9b6a3c4db06c23f5939fed84ecf5b7"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  def install
    system "nimble", "brewmake"
    bin.install "auto-editor"
    generate_completions_from_executable(bin/"auto-editor", "completion", "-s", shells: [:zsh])
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end
