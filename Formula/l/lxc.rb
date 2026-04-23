class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.8/lxd-6.8.tar.gz"
  sha256 "4ccfd62b4364bab41f537d5602f2c16f86dbe57f218ac225afaeba86b5decb3b"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59a635679e4b44072152ac8e10a7224d2e8053f6bd4c1c77b18122498879b75b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59a635679e4b44072152ac8e10a7224d2e8053f6bd4c1c77b18122498879b75b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59a635679e4b44072152ac8e10a7224d2e8053f6bd4c1c77b18122498879b75b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe34c778afab192d6096b98d23f9b7ab5985ecb9cfa78f82fc7824d482329dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77a7f06b8e67039c50210013571089b078b78ef1cd2f70024356574a9e525980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dafcbd6d0128b629e5dbd7acb4c4bc070793b22ef276010b16c8e2a9dd6a421"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
