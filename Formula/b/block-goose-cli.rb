class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "d94935a7827a92a422fa9482e23c3c854787d88543758701242233fa56190cf1"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37222ce0edd31d0ddc18b17d9506f9b19df32efd10bfba247ae17bd5b3b03697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feace1fb4248ecda17f04ba8376d867f42aab219a9fff1730039076504cded7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fbf02a6b86f42de8b31d00bf5ce8cd323fe85fa210241962292179c0bb4b7f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "061c2a153d42e20ca85859e368acf4c998081fe2bba0bf0c45fa3c0c707f5cd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d48f9f326581dd58c472a0d5373e525f6b8191c871c651ea45dbe4f4424d5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98769954e24c2fef3f010eb77a4a5895b171c9ceeacbec8cbf7f89e0099e978f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")

    generate_completions_from_executable(bin/"goose", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
