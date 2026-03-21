class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/refs/tags/v5.34.2.tar.gz"
  sha256 "3b120d232d9039d10f771cae4f61f4c0c5a8212f0b074cdd69ac55c28fa6ba9a"
  license "MIT"
  head "https://github.com/dundee/gdu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8dfda0a4e211c4c7a913409809945ba6b6b84ca6732d15697aea8aa5c2807c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8dfda0a4e211c4c7a913409809945ba6b6b84ca6732d15697aea8aa5c2807c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8dfda0a4e211c4c7a913409809945ba6b6b84ca6732d15697aea8aa5c2807c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3db1f376536380c69affd0c0f67006b3407c32fce46449e919e0adc424fa7c90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc7f7ed5c8311e3566bdac6ccd0fc3db71140a1ab05fd996be9b422f877e6e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bce95dafb280c046ce08a40d7c75389a00720330eb8fc0ec79cc6e39e6c3b08"
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
