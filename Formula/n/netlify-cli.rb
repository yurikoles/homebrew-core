class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-25.3.0.tgz"
  sha256 "6cd70cb1b8c426e7a70ba230fb735034f75c18f7264b03c9a1542d0441815259"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b73baa99ffe378c77da2a01e45df602d558a8e2959765216c3de37f6f04608b6"
    sha256                               arm64_sequoia: "6ac0098711940f6ff84869d4f9c1b34fae21b830c1691cf7c8f678c8c058d485"
    sha256                               arm64_sonoma:  "cdd89f42250cc8a79f77efd2a18f501ce548998710a7ddf4148c05bf477ca67b"
    sha256                               sonoma:        "04dc1628a8f0bf4a707847519a2dbaf486973c100d0768f8fb2b1d71d1976352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a12e37ab6c270c0ae183d809e5abf1df8110982e1d09464ad2c7b36ba57003e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5e338010ca6a09bf0cd643a6d7e0b31d1bdfdceaf9ef6c772f82dedc4afb18"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "xsel"
  end

  # Resource needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible and unneeded pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir, force: true) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/netlify-cli/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = Formula["vips"].opt_lib/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
