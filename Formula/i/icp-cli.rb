class IcpCli < Formula
  desc "Development tool for building and deploying canisters on ICP"
  homepage "https://dfinity.github.io/icp-cli/"
  url "https://github.com/dfinity/icp-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4bbe414eff4abe90f625628e2a4a0affcb7440869ba92234cb153ca68f673e97"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2be5acb73fd19e41e6a6b32d9a21eab56f1f7b06f5e51819ac62f094efabe0f1"
    sha256 cellar: :any,                 arm64_sequoia: "b6f4adee98cb8f31ffc7c1f36200ef766e08fd5dfe017718c960bd9165937e65"
    sha256 cellar: :any,                 arm64_sonoma:  "89564774dfe7331d7151556336a88228add0f3c338b2a3047c286b7eb1666c19"
    sha256 cellar: :any,                 sonoma:        "a3e2a6ca0e20e76f88e2b712d5ae258ffe83050ab46e7bf19f9cdbb13436cd23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86d2eae198577d82d13e891983736ff85344c0241af5fc4a629f742c01f26dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4c8aa8185b9721c0b61e568cc04936280becef8e4ca2c1a5efb313b3727f744"
  end

  depends_on "rust" => :build
  depends_on "ic-wasm"
  depends_on "openssl@3"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["ICP_CLI_BUILD_DIST"] = "homebrew-core"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/icp-cli")
  end

  test do
    output = shell_output("#{bin}/icp identity new alice --storage plaintext")
    assert_match "Your seed phrase", output
  end
end
