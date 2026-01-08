class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "656e47a82a467e43ff3b3e3420be1b0ddb6365283ec554c0f70e0926d634eb57"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c319dd4fde835c5205415d8d9a4f01bc86d7d6b305fa105240838e5f71ee2377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "796ed25c512d6c0653c684ab234bdc634c22c2c57b69d63dc5d65b40e1134ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaa2178cb1b2f9e602df82d0be10862c16faa4555aa6bf744f62a66844c1fe9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3707bf9de59046d94600b5aa24cdf764f5aca61b4389c07d509b563626185578"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fd619e2b930344b11a06f25eef6518489e9137c4617f899b2ce90293b6cec59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4dc3e4bb43f1385e5e5b0903b624ad32f49f4ee4960641bc9afa22d66ce3929"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
