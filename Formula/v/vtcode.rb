class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.96.15.crate"
  sha256 "39e644346ac457d5d27ca114832bc5ad9906c12cd5afd9cbac05bd3221dc5ebe"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0067c11e7700e7c4961820ee094929d98f9387e37b922810034069b2c2c1139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d2b0fe575d75134049d401df08820adc2e17d7aca685b7652ca1763468ae96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "181b61062468324ed89e6684ad8f81231796d7e0145a81a0a6d606b7416ef5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "22e37bd41e1abf0d83731453353c50d0eb9e57a6ac4a28716f678086bd55c1bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2545653d7355d2229ac1b66d99ca2bd270a6524bf177ad3214ab7adb5a34bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46283434b665aac813030d6dc039a2f77e992b51f8a2b237503fb1491ecaa4d7"
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
