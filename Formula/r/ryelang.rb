class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e7dc24cd60c3f23ffad0f357ed143bc7c96a02fe244a3a9d535f3b9d0b97be33"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93378eae370d5df058ee4ca4f6b8b71bfcd71977f8079c94483d2bfa6b3a4467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5214fee3387193533160462978985d90065ee4838a7658d6cc9db03d78a31b92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48677554b602a45ac7bbbd7aae77689b7f47f1beea577ac5356f75368ab2a5d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "149f3e44ed56197637cf03979c7331d3d13201bda4af2e641b2d741bc4b76752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af28a295f5e112f3cf83fbcd3f87ea6f87d588c523435177be3f023849829df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53308a24cc04292948fc73015d719d13c7432fb8adf18ce624bff2d818e15fa"
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
    assert_match "Hello Mars\n42", output.strip
  end
end
