class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.68.0.crate"
  sha256 "c5353c8e655478117422b5a62d576c306ecbc0dd15b27667d0f1f9f7d56fe57f"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40a7b8af6553f7d0af836713045f0e55fb77732cd0e803ded9b7a0c6261d2247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d4454cf87ad893d109c1caaa6b472ed955ffc7d14e0b88f389b85db9461d8a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faeee497c2915402fa53e14c31e10aae23160a9bd26a5bad463dea6eb3c9b04a"
    sha256 cellar: :any_skip_relocation, sonoma:        "04df50f121d5dc349cba330976ddb3f33fec5205829023eec9b3d9be9a20bd67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c51d14d4fa4423b39b6011509db1d51291a9639c65f6a37fc425317540b25ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0cb554e9d74a68d19702d57633a80f3a22994cda9c63e72c651922e75567ffb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
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
