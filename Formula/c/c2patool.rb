class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.37.tar.gz"
  sha256 "9140c3e0d3d5b4e1d55c3d0e1ebfd56b37ffdb8823e543ce0e4ee6b0dead31ff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ba3f88849eb59e0faea2f942add07f4471a4d3c4ca3370804ae5a152c5479f6"
    sha256 cellar: :any,                 arm64_sequoia: "9389872ee467bc60dfe508363ddce442750112dd915a6fe26da2fabda9cb3a5a"
    sha256 cellar: :any,                 arm64_sonoma:  "481be50d32b87495a20d05cc69eda8de7c087c24b4afc2a35574e6dc72aed4ec"
    sha256 cellar: :any,                 sonoma:        "305c621b701da795c2a71955b3babf526c16eb7652f1da016170b04e5c21e929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af9b503b8ee1b26d9b7206c802a5f5687ea86e493e1f64c6b2e99a8bc209a9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b002b27f8652a26dd8a4b691ea9dec66f135fabd26652fc24485e17daf4971"
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
