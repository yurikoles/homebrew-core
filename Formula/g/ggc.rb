class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.4.0.tar.gz"
  sha256 "d319caab311aa70f577ddf23773284f2ad3f3b34685275a2b24ca887fef02f2e"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca25e9cce7113a8d85f9e4151e1806f485706bcb4dd6ec609bdee66d079a807a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca25e9cce7113a8d85f9e4151e1806f485706bcb4dd6ec609bdee66d079a807a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca25e9cce7113a8d85f9e4151e1806f485706bcb4dd6ec609bdee66d079a807a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1b162d0eab7f0db40f14e571cb817d0e18138b5ff4fced8e46cadf78562930"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b26bcd13c7471e8e40352a6b361420defca10bb3e5b8507d4be08aae8665a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc09146738530121542f20562a4e186c79ecad87f73eaf4efb783005aeeda843"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
