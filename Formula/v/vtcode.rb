class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.89.0.crate"
  sha256 "1e5e08b8cb2425dc37839b356b22f1e71a91a9428dc8687d8dc2c6eedcb761ba"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdd5edec982afcc3f22c86d2d85faa11de1241b88187f54462ecb461de0f364d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43978583e11f1e17f0ab36611a5d2965e08d7c26b1922b4e34e166ba66ddcd1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cab50e269829c06932a281ae03ed64aa37487dcfb61b5cf3d617d3cd6c1c0e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3088a271f3211b00b7a1ae46f760b15367c5f3448c652419d13fe7be413496da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9a61000f7c18452c23716275c5408e5441f6de49517f47cd5c376d30ddaea0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da4847cd023c41511c115f78161d6d139fc83ac743723a4f3f504d2ad5000ad8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
