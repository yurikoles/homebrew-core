class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://static.crates.io/crates/checkpwn/checkpwn-0.5.6.crate"
  sha256 "c7540e67a6d25bf68926084d76a09866a9fb9eb265a2b4c21802fcbf741b51d4"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f44949d541a5090722b28b7476c2e2ecd71dea26c57496e9f301478e1fee73b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "231523bcebdd1c6bae0fe105089e7e8de4200f3487e91c7858fa23c32851c4af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7fce288f337d494af4d34d5c9125a222f05d2f5a35de1757870a8f5cfcea627"
    sha256 cellar: :any_skip_relocation, sonoma:        "79e425de48f6f832a02233f0643995d7f1d4656788fb4a5c760599a4e447104b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb39905fbf588058e688b7122d29ca7d029fc297808f1849e3d5fb4c127ba293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aec0949f0c719a7bd263984378f48bbf58a0b922a6b2bc3fc06cc5c1f9daedb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/checkpwn acc test@example.com 2>&1", 101)
    assert_match "Failed to read or parse the configuration file 'checkpwn.yml'", output
  end
end
