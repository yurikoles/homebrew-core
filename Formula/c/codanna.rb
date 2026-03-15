class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.16.tar.gz"
  sha256 "55d21511c1b5aca1c6a9e200656fa8042f4bb0701b99a2f26289f5a207c637a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b0a1d57a458ec526ae3d25c714157fe3b23a4a6d654e4fb8985f38756c257b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af2f0ad414271018cc71b152a3fb70b020fec9c52dc09260adba8c764f81388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42a46cc4f0c369fac9e0a181af8bfad14af53743fc9df155027746b760468fe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "08a2895a7d276bde28e3a3ce5f3c3610a872d6ebc60fc830e2f562e85d190e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6216605e85098732ef8dc137d444286648a41761da61d2d1b45457be5c23eff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d26926b78940d216c8b177edb296140e09a12ad29513cbcd75c33b9e9935f063"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
