class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.2.0.tar.gz"
  sha256 "e1416a79cb3b6c0186336ebea20ee0d562c27f1072cfb5e9332055d719f20aa9"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e00717894445c6f3d2ff06f42c89972364e1e971efa07582cbfc8428dc1c505"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccdf1f2d610d06ca855cff459cdc54025ac76cdcf79afc18d3b0c1d7bae05c73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bcf12601354d2fadc62d4627c16c99871cae513d611906641592924a206cacf"
    sha256 cellar: :any_skip_relocation, sonoma:        "64fb7623190a03adf4bf2ec3e2a81aa69d86ec77a0b59afc55c856757991c70d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3d02add74e8622168baf9f045d0852c7ba8394872cc20324353df432c2d19a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "080de8946b66e8b88dead17b26334d9f235dcfac041e291328322e64c1fdfa2e"
  end

  depends_on "deno" => :build

  on_linux do
    # We use a workaround to prevent modification of the `fedify` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix
  end

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")

    # FIXME: patchelf corrupts the ELF binary as Deno needs to find a magic
    # trailer string `d3n0l4nd` at a specific location. This workaround should
    # be made into a brew DSL to skip running patchelf.
    if OS.linux? && build.bottle?
      prefix.install bin/"fedify"
      Utils::Gzip.compress(prefix/"fedify")
    end
  end

  def post_install
    if (prefix/"fedify.gz").exist?
      system "gunzip", prefix/"fedify.gz"
      bin.install prefix/"fedify"
      (bin/"fedify").chmod 0755
    end
  end

  test do
    assert_match version.to_s, shell_output("NO_COLOR=1 #{bin}/fedify --version")

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end
