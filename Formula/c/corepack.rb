class Corepack < Formula
  desc "Package acting as bridge between Node projects and their package managers"
  homepage "https://github.com/nodejs/corepack"
  url "https://registry.npmjs.org/corepack/-/corepack-0.34.6.tgz"
  sha256 "af29678fc25ed5ae02343e9b67b214a25bacdcffae566f8cf848936beb23a7c8"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/corepack/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6017d035a9a893aedffd5913239445146f4844bec601e1d01f700af99b355221"
  end

  depends_on "node"

  conflicts_with "hadoop", because: "both install `yarn` binaries"
  conflicts_with "pnpm", because: "both install `pnpm` and `pnpx` binaries"
  conflicts_with "yarn", because: "both install `yarn` and `yarnpkg` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"corepack"

    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
    system bin/"yarn", "add", "fsevents", "--build-from-source=true" if OS.mac?

    (testpath/"package.json").delete
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
