class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.21.tgz"
  sha256 "5789432cee1546ca2b3683e62b20f519b3e1ce4866f0181d185d44b883bd17a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b5208b08086979f10064769ae8f19c59d65af0c2869677409574b59310cc476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5444b55a3ce9714b51dfb037952251ffc06fe30543995c562de346689afc6f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5444b55a3ce9714b51dfb037952251ffc06fe30543995c562de346689afc6f87"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b6cdbc4304d23f813bc9c86b71bf7515b8f0d4adecf7725725f82314397907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afcf209da2d3789e307625620510492f594d7e7b9f59ba393058b831b7b34861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afcf209da2d3789e307625620510492f594d7e7b9f59ba393058b831b7b34861"
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
