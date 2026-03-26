class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "0c346a32338c8b82ea80615a51080a5c67f30d1ff194f763e0316e89522fdba2"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd8b06861d6b86f64bf1eb47b3f8628a9879c4be2ccf3ed772157fce171e91ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd8b06861d6b86f64bf1eb47b3f8628a9879c4be2ccf3ed772157fce171e91ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd8b06861d6b86f64bf1eb47b3f8628a9879c4be2ccf3ed772157fce171e91ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "a64772100fb125322e607ce829505af09a2a4bf5be544930cf29987cafd74e1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0099d6d6aa2bb74dec1f372df837c7df08aee9cd9cd2dc0f2f0b0db9bc51b41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "364e12c208ebd9a3f6a9cc340029b2df203612340e5f84be46556b7f72661745"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_path_exists testpath/"test.txt"
  end
end
