class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "11acf25d9c7b948302816d26230417b366c4c4433845c9f6f743f38ca6380f1d"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfc3316fb5efca91707889859ade829e6b979ed7ac1f8dafdd9f8d0cf15b790d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae7dde165905b2aa44fa82b49c259d972ec3908850fe5dd7aaf94c7487cdbdff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58ce6ca840aa64b073760b90864f574a41886434fc5530ac1e12d4ca1a45da86"
    sha256 cellar: :any_skip_relocation, sonoma:        "e80db98a04bacc0eed625b1203d461f0a51928c6f73a598824e947ed05e6f380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb7ba7e94a3802395b73e854af2d2b42c3558478a0907936eee93bc561b27e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb071dd5a615f8951c2883526604fe2f435f2242a3b851eceb99a98d1bcaf778"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tantalor93/dnspyre/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end
