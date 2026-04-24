class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.38.tgz"
  sha256 "b9fff431b3f671b9e6c37aaf26e993968f38769546a12170b2e6179f5f38f90b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf2360413826a9677a190cd43175e428d1d39b9d6cb3a924bc2ebd8ab30a043b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfdb65ebeef920ed91562fcc150756766d867c40a233506b347043db9bd457b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfdb65ebeef920ed91562fcc150756766d867c40a233506b347043db9bd457b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38af0758b9f569aad0450cd7c37f23029dee81118ced3ab15f8f06d556bea58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88b2729c14dc16d3ff1b285a8988406aa5c050a5f85e2994f36c6944196be682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b2729c14dc16d3ff1b285a8988406aa5c050a5f85e2994f36c6944196be682"
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
