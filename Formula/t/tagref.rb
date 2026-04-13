class Tagref < Formula
  desc "Refer to other locations in your codebase"
  homepage "https://github.com/stepchowfun/tagref"
  url "https://github.com/stepchowfun/tagref/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "3d0017911afb6d9b887444c6da32f1642ad4046b4098af3d412fae1b58fece8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4abdb34c0bd0b022c53572a37da6201efb4db42d92989d4762157280ca0262cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67464623ed77a5b0efb05904dd1563383e3a2e21dd8925466d2e3586307328f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9a82f031abba32c183bd013efdb8d1f405163c53ed2aabef2c2c7b0cc1a002e"
    sha256 cellar: :any_skip_relocation, sonoma:        "318bc6f7fd71c2c95c956eaad7f56fbd8e604a1966d0ffac75073f21db60bb32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cc27f35dfd6a0ceda12820a8841be63968068babbc9d2c48151cfba194536ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3665532ce93d29b609bf31587843400fe1bf40ef5efa0b9fa01400af31ec1215"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file-1.txt").write <<~EOS
      Here's a reference to the tag below: [ref:foo]
      Here's a reference to a tag in another file: [ref:bar]
      Here's a tag: [tag:foo]
    EOS

    (testpath/"file-2.txt").write <<~EOS
      Here's a tag: [tag:bar]
    EOS

    ENV["NO_COLOR"] = "true"
    output = shell_output("#{bin}/tagref 2>&1")
    assert_match(
      "2 tags, 2 tag references, 0 file references, and 0 directory references",
      output,
      "Tagref did not find all the tags.",
    )

    (testpath/"file-3.txt").write <<~EOS
      Here's a reference to a non-existent tag: [ref:baz]
    EOS

    output = shell_output("#{bin}/tagref 2>&1", 1)
    assert_match(
      "No tag found for [ref:baz] @ ./file-3.txt:1.",
      output,
      "Tagref did not complain about a missing tag.",
    )
  end
end
