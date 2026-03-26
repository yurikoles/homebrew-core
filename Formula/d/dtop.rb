class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "3c7de485a14908edb280d55116c8ab82a08dcd65c327c839971db79d0e7800ad"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e001e0c731fe61b945d86dca8fc3fc1b986172fa85a742bacb37c351d73d7da1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56237d4e091de9df843f2acccc384ece1f4d6747672be6cfe31a724f40d1983d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "246407fd691ab460b345658899cfc9e8618279e59d36869001f36e2ff09dc7b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5cd7f6d3d5468f2c9c2ef124b0126aaf93a29ed9a6cf9cdbdc78bcda7052843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "644ca57a16a9785ed6eb1338fb4602d7efb6701e00a446ffb6764344415f9130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b9f6bc3ea5761468853ef94029c41c8b657457a39d985db655a186c7ca3aaf6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
