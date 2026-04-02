class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.65.tar.gz"
  sha256 "3b812d11d2dfc662d6df3d5b62225edecabe7cf1a85ccea2351153088f24562d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c35e468593452c801642b471a8e3b4fe0cc4cad1ec07c89d9a41cf9eee3010af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78a1f4004811cc861f9cd6f7b29e749eb622710f91ea27be40f5fca483977a63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c688b89e199b04df8afd460501622cfad29838339baef80151e43d87df2ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "910680c7f82de83e52e0ba550b01b75d08d500f0e51cd5e8f7f8280557932077"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd7b9e0a0088e9607ad62d244f8efca09f2889f2792cd8bcacbc7f40182db65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdaedc486033f625a30ad58d65e803ecc799e898bc608825ecb73cf52b168e1b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
