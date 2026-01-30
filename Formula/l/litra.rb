class Litra < Formula
  desc "Control Logitech Litra lights from the command-line"
  homepage "https://github.com/timrogers/litra-rs"
  url "https://github.com/timrogers/litra-rs/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "c17bcd2afefdc9634b22319a88ea3f366b724c046d84ca744296365574c69123"
  license "MIT"
  head "https://github.com/timrogers/litra-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6f2b88475cb118a19e3668b15ce928bf2e4fa31c2124409ff04af1a0eafc67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac5f7dae722ea35cd485cad20d67675f3e52ad5028cdc45c77b0ee625b47970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "369766ce4d20c5be2d25f770a716a1f65fb1f82d40a9afc80b57e29bfef269d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f56c0417c7b63273a7886469dc99cf2c2fcccab270dca2cba4b2b5b384dacabf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80bacf3f67b49fc6a1b78aa63475e917cd2a0ca2d5a258ea196b348314cdea3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8115333877484cbfa51207c607d8b2fa66aacd5de27d4a37f7a652870308f60b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "hidapi"
  end

  def install
    # Update to use system hidapi for linux build, upstream pr, https://github.com/timrogers/litra-rs/pull/210
    if OS.linux?
      inreplace "Cargo.toml",
                /^(\s*hidapi\s*=\s*)"([^"]+)"\s*$/,
                '\1{ version = "\2", default-features = false, features = ["linux-shared-hidraw"] }'
    end

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/litra --version")
    assert_match "No Logitech Litra devices found", shell_output("#{bin}/litra devices")
  end
end
