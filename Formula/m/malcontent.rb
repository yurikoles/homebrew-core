class Malcontent < Formula
  desc "Supply Chain Attack Detection, via context differential analysis and YARA"
  homepage "https://github.com/chainguard-dev/malcontent"
  url "https://github.com/chainguard-dev/malcontent/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "e0480bdf61776cf71f561dd04898068c8ee926927a54d65dae34027b8caaa8c9"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/malcontent.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6565e666cefe6c2d7fd4d5fb62b893f84664492672ebb7638717e781055fabfe"
    sha256 cellar: :any,                 arm64_sequoia: "d24f73afc2458b3c3373ffd9805fd1544e90f52436d83276c00c21e861472beb"
    sha256 cellar: :any,                 arm64_sonoma:  "897a811141f801303826bc9e266c01b012713a35b7cc9708e672c7b98b16654a"
    sha256 cellar: :any,                 sonoma:        "9f9f7708d13e8179c0b6cd7756e0d315c026c8db2f621f2938d14c6335c85b75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8346c8f397a61586485cdcaea4a251089ec0fbfa9546186e7269caa5373ce5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daf1a056301fc76e34502e2ca74ce3f8dfdfc1c82beb9c6762f66882000fd1ad"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "yara-x"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BuildVersion=#{version}", output: bin/"mal"), "./cmd/mal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mal --version")

    (testpath/"test.py").write <<~PYTHON
      import subprocess
      subprocess.run(["echo", "execute external program"])
    PYTHON

    assert_match "program — execute external program", shell_output("#{bin}/mal analyze #{testpath}")
  end
end
