class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.38.tar.gz"
  sha256 "f0bb9836ad95fa8acd3b0f8d5f8a6cb422f4f695a2b7216e15ec5146626d0a3f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45dd60715c24591b80208b81dab64e1e9b83d0cae2a267bd42818172b5b2f9da"
    sha256 cellar: :any,                 arm64_sequoia: "5e990be7b5265e474ead21285204b7d7b3ae642cb61c74a05b684a1d59bf2a9e"
    sha256 cellar: :any,                 arm64_sonoma:  "d3bf8919e609bc531bb13c5fb07d32f77046a65037dce8badbf98eb674623264"
    sha256 cellar: :any,                 sonoma:        "497ad6597754c1ee3eaf647a08692ca1cae8041a4107a301f8e4b6001ab3e263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c16c2180ef165ebd5bf47769eec8e031d059e68205126b0d3caf11293d19526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edd76b827ae343f1c43fc4055b0cc1fa0a1b45c2e001f89162ea7b32d4180c65"
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
