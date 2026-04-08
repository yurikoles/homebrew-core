class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.45.tar.gz"
  sha256 "9e8483132631a67676e453d6dba8c83857d678b7ea3c6efb6d18e569f2580590"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6838e46da658d43f61ad7cc1a62811d3cbd88c767d5c0fba9bb3cf48cce27848"
    sha256 cellar: :any,                 arm64_sequoia: "2c32b4b33218bab2aac6266fff39069dc4949b4eeb5d0421716aadc7473d52d3"
    sha256 cellar: :any,                 arm64_sonoma:  "8531af0d90b79acab9f38f1da2cced642bb04b209d3d5e0cf0be1f723d91100b"
    sha256 cellar: :any,                 sonoma:        "74c7032c4b90871bdf43bbfc40bc3467ec80b37e00da5f89ea12d03b165ee402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2087b471151177b3205c082a6bf8fa4bdcb53c0d18255e83041ba99567780fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa0fdd7d4ece0cb86f34fcf4e4c3733ac79e43f4533afbb190049e5734577bb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end
