class Lazycut < Formula
  desc "Terminal-based video trimming TUI"
  homepage "https://github.com/ozemin/lazycut"
  url "https://github.com/ozemin/lazycut/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "550e4c469cba1b577ce0e6ed7a58d0e131f9e7cf432786ed90ca14a2bc1b4635"
  license "MIT"

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
