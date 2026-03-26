class Lazycut < Formula
  desc "Terminal-based video trimming TUI"
  homepage "https://github.com/ozemin/lazycut"
  url "https://github.com/ozemin/lazycut/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "14c18eeef885c90a1660a85d760b0520d1d2256b38e4f5fe5b750f0d34baadd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25e1557b86f739867e36946452d58fbea28cbdbef7b02fbee275833dc815e78e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e1557b86f739867e36946452d58fbea28cbdbef7b02fbee275833dc815e78e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25e1557b86f739867e36946452d58fbea28cbdbef7b02fbee275833dc815e78e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7691261be4c52425845fdd53ae3ccddfee0392ace11ad2ac109b5707aa5dc1bb"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on "gettext"
  depends_on "glib"
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazycut --version")

    system "ffmpeg", "-f", "lavfi", "-i", "testsrc2=duration=3:size=320x240:rate=25",
           "-c:v", "libx264", "-t", "3", testpath/"test.mp4"
    output = shell_output("#{bin}/lazycut probe #{testpath}/test.mp4")
    assert_match "Duration:", output
    assert_match "Resolution:", output

    system bin/"lazycut", "trim", "--in", "00:00:00", "--out", "00:00:02",
           "-o", testpath/"trimmed.mp4", testpath/"test.mp4"
    assert_path_exists testpath/"trimmed.mp4"
  end
end
