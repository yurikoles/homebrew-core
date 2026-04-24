class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.24.0.tar.gz"
  sha256 "e1a92b9660140f53bdeea26815775c465640b0c09649b1b395f7fd471b057856"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc655b833a71ae76f12fb96cdef6edcd6dc99a45c3e8526a11b8ef8f48e1ab43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32234fa2157678726d3fc4a9a663e87f193375202daa93ef5facdc85d172e5e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "144e3ce2caeab54c24f83398759d36d18fcd8cc800ea81d51918d344161da906"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c482039779ee156e73af0c760e61728bdc9e67bbbe810b6c8ff3ec08bed368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b674aef5069addbc961c55ddc819eac3cb44a6f6d7bd0f0da286788bddcaaf93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ebb7248c273b09a89e60ad8dd44f28b3033fd0ed55205952d0042e21c9303f7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match "🔍 1 Total", output
    assert_match "✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end
