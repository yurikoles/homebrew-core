class Mkbrr < Formula
  desc "Is a tool to create, modify and inspect torrent files. Fast"
  homepage "https://mkbrr.com/introduction"
  url "https://github.com/autobrr/mkbrr/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "f071ec9bb77bf56b5971dcb2ea47a2764b61d5778f064d5b052d1200fe6967b9"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/mkbrr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d476d4bc162f3af9d43668ca6df17eac12ee8588b8812fd60130f65ac1d02c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d476d4bc162f3af9d43668ca6df17eac12ee8588b8812fd60130f65ac1d02c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d476d4bc162f3af9d43668ca6df17eac12ee8588b8812fd60130f65ac1d02c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b72306f01c6508615620e5e64122645da6b1499872077674ad96cd0612b7703c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "300d61e21d27ae2002f47895e38c360ab576406dca61fc753f5e715bd9bc7334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6c8ee75d64c6def837c8666f9bdcae6aae23380d3289ad9ab52b3d4285f90c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.buildTime=#{time.iso8601}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mkbrr version")

    (testpath/"hello.txt").write "Hello, World!"
    system bin/"mkbrr", "create", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
