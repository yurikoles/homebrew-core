class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.24.1.tar.gz"
  sha256 "51bf8e1ca4da4ea3a326bbfa163ef68920bbc8dc3b84bd094bc86e43fd674e36"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77f3e43bd1a7de0fd6aee8f91c204583e16461314b4f2abf200930ddbb32fb2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbfcaa9c9fcf5172ec61ee4f30ffe3174a3f8db90e50865ee503cac218290072"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b6ff3605430d0b0e7181c173d8c3cdce433885a569f1528aebdf0331545302d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d72be9f1424c42423d0868b3e51c0065b7794def48025921ac34d107d7d6a9a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ded585b91b995517332cffde1ba570fd03901c7592bdb6b2db52fda46237fcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d4360e3fa311716e9a3260fd73719969b19178226c53d4bfa0248c620871b3c"
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
