class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.35.tar.gz"
  sha256 "67b275f51fff7a331ca9ea590da6d05827e1c6ef30d7641d20d8e2d431412c0f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ddbbc1751a28c148c1ecd9b1bfd262466a289587fa206f7ac232f49213b958c"
    sha256 cellar: :any,                 arm64_sequoia: "b90d917924db810f59e8763be82187b03ce0e2bfd0dda3e9b32929bf986f4f39"
    sha256 cellar: :any,                 arm64_sonoma:  "780b86f283d47a206252f475a3f07235f396bc71982cc3ca5da528b3614ee583"
    sha256 cellar: :any,                 sonoma:        "b8879410689747a1506772244278d3431e32405d5d73d361237654571b9e26c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef596db83304073f43be54b040d2b5aa260744c60c2b9d2962af4ad0b3327dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82482cb3ee7bdb0e447bc663360fd950cfe87b002d75ae9dccaccd044266930f"
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
