class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.34.tgz"
  sha256 "e029cc3fba9f904ca487e177c227496d89964954f74ed9842e79e968a5e2385a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e587402b8cfb23cd9f85550f7b3fcbb98166abfe32d14d29f6e2b8ef5dc793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220ca76d71db1fa55ba676c3297e386595b51db62db839d3f37468166a2380d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "220ca76d71db1fa55ba676c3297e386595b51db62db839d3f37468166a2380d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce5cf31d7619d57233735becb520173665f81c4944ad58185fcc0f43af07f9a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3b5ad829292c763ca1f00cbbecbb4de8b7ff2fc4697b3d939f9da36dffa2dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b5ad829292c763ca1f00cbbecbb4de8b7ff2fc4697b3d939f9da36dffa2dbd"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
