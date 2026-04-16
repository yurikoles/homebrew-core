class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.9.0.tgz"
  sha256 "f701aff4e850003e3bf551688a5945396f6d2d2a1af73cab23dbfb020ed87211"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc2c8cc8388a6bb0edd5faf3c9f419260cc22453fb965160fc14733d40f05a69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc2c8cc8388a6bb0edd5faf3c9f419260cc22453fb965160fc14733d40f05a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc2c8cc8388a6bb0edd5faf3c9f419260cc22453fb965160fc14733d40f05a69"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2cf78aa0b845375bf15b9be60d8f047b13aca56c21dcecbc92a0c15b33dc6ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe5584d2424bb41905c61359a140bdd56a4f5a2fe1fbb23069171e8ffeb36994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82fc18a20ddfe22e4fa1b61e2d75025b3ea18605d7f301f43c98ef85b4de4620"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end
