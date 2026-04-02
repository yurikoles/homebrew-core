class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.27.7.tar.gz"
  sha256 "a2569028ce53f06531794e67388e760b343a1d5e77cef446a6ec07eeb96137f0"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66150b8a614f270391771e2293bedaa98c6481d7187aa8374d5be2cec3e666f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66150b8a614f270391771e2293bedaa98c6481d7187aa8374d5be2cec3e666f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66150b8a614f270391771e2293bedaa98c6481d7187aa8374d5be2cec3e666f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b3267efa6cd1d8f6a2d6960448ef92ee3ebc635d39a6d09c51ffd30c4e7d3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b95f8ec4289698d32f2229e01aa3f3c7758b080b6082ff881d2aade5ad4d9180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b85ea56f2c333004806458e59947890f8efa27d99ade93c9de58da2959ecd6a"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
  end

  test do
    (testpath/"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
      process.exit()
    JS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
