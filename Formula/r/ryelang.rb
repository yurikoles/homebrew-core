class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.99.tar.gz"
  sha256 "dd99cfa0d3d9a612d29f0adac2e5db1d608b7309582f8854414fc025fe5a837b"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72db5979c00b3226f4a4164e52a98d610d1272d951ef3ac6435b84cbbcae5c92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3093c2c45ad2e50948e0d886dfeb0ffc70e1f845352556a32205dd4eed22a891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a3a3b4d52d2f2a96689ec607e6265c861fff82103a6e34c2de7ac730eb823e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95c1e106436cee7323abdf1afa1127af67b380563e4853551e2389388ec4121"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae36d44474208802a16c7c551899f6e40b1890c21e281ec0628fc47f72d64fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a83947fe787458eef1d60b5644e027a9e4d884452252732873cb934edcaeaf87"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
