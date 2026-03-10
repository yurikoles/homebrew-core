class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "e354fc6235848ca0453c847b4590120f8a7828c703a83e8eb62434d8cc7467cd"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c2d958307cfd0461c0b6263aabaa65113672968626a22f1ba678b316ea317e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "641aac76e48c49ff244f6ef282a6c3f76629f84ea6a49a30d36c5de7709edc79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f736e85b9e1570d1043926875e8f9831156f407d9b19bb8916e294d46ed712c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e034711972286eba231d814b8e5c266251142f2cb9472ed24b82b849d8c6ba08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d02609cf0ba50092c0a5bbc135c8090a20d9471fe19e19e5e798300393099a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17a287106a02d145ea6d8a1bd1591da93f84a114a3f24953e51ecbc52ecd634b"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build assets
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build-css"
    system "npm", "run", "build-js"

    # Build and install the binary
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cook --version")

    (testpath/"pancakes.cook").write <<~COOK
      Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
      @milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
    COOK
    (testpath/"expected.md").write <<~MARKDOWN
      ## Ingredients

      - *3* eggs
      - *125 g* plain flour
      - *250 ml* milk
      - *1 pinch* sea salt

      ## Cookware

      - blender

      ## Steps

      1. Crack the eggs into a blender, then add the plain flour, milk and sea salt,
      and blitz until smooth.
    MARKDOWN
    assert_match (testpath/"expected.md").read,
      shell_output("#{bin}/cook recipe read --format markdown pancakes.cook")
  end
end
