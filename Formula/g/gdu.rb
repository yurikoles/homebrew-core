class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.34.4.tar.gz"
  sha256 "81aef5ae5f0137794ae0385cd9b041a8772016ae9e19f5f071e17f187cbc6832"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42ea7a76daacad010a0162e6f92d8dda298f03d3b8dd9b6c6b0599a901042586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42ea7a76daacad010a0162e6f92d8dda298f03d3b8dd9b6c6b0599a901042586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ea7a76daacad010a0162e6f92d8dda298f03d3b8dd9b6c6b0599a901042586"
    sha256 cellar: :any_skip_relocation, sonoma:        "d336605438637878184b9a92944028dcf3eba89dc6ccb7b9ba5819709d903dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d7b6ef957765283bfe0155a74a1441b1683d38c674f9a02a0f646280360102b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c626a083038953d198dac48b4fdf58321b7c2d796de1ae730a50eb3aff079c7"
  end

  depends_on "go" => :build

  def install
    user = Utils.safe_popen_read("id", "-u", "-n")
    major = version.major

    ldflags = %W[
      -s -w
      -X "github.com/dundee/gdu/v#{major}/build.Version=v#{version}"
      -X "github.com/dundee/gdu/v#{major}/build.Time=#{time}"
      -X "github.com/dundee/gdu/v#{major}/build.User=#{user}"
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"gdu-go"), "./cmd/gdu"
    man1.install "gdu.1" => "gdu-go.1"
  end

  def caveats
    <<~EOS
      To avoid a conflict with `coreutils`, `gdu` has been installed as `gdu-go`.
    EOS
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir/file1").write "hello"
    (testpath/"test_dir/file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu-go -v")
    assert_match "colorized", shell_output("#{bin}/gdu-go --help 2>&1")
    output = shell_output("#{bin}/gdu-go --non-interactive --no-progress #{testpath}/test_dir 2>&1")
    assert_match "4.0 KiB file1", output
  end
end
