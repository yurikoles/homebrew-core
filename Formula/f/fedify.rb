class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://github.com/fedify-dev/fedify/archive/refs/tags/2.0.4.tar.gz"
  sha256 "d2a8f059ad8e23aee886e689e2fa8b62d689123ccf53c920b8fd2c3b6f1ee05f"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9b2827315a63cf5b3be9daf1f42f35c415084b52f7caae6ffc1fea12086f041"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46a48449a7dd734a4ebd2472341f3fcfd653d781cbc5e5c09462ebff5fb27a8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8623c14d2be6fb583f4ac5c5fd27d045d814df554e090a12a27647d0e8f9ec1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d103b3c676adc732ccd095ed7eee86c41ac94c6db93f94a89c7c7c1a8b6548f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "263f8c71fb92e3d6ff5e7f5e040c041bbc1ef001f966b500749e0cef67ceda93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd45f96b30425b94b7f1995b890b8968ade278cd0c9998093330ad8a80dc7edb"
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
