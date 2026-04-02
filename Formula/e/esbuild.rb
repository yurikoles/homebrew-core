class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.27.7.tar.gz"
  sha256 "a2569028ce53f06531794e67388e760b343a1d5e77cef446a6ec07eeb96137f0"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc467eb1c46c7822f56a01bc83d64957e6fcd300ef41a06adc37b3d46b0e7104"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc467eb1c46c7822f56a01bc83d64957e6fcd300ef41a06adc37b3d46b0e7104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc467eb1c46c7822f56a01bc83d64957e6fcd300ef41a06adc37b3d46b0e7104"
    sha256 cellar: :any_skip_relocation, sonoma:        "064f2b7f4821b182dc351ba22c6eaee53d52b3750741ec8ea3d8d3666fa6cf7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06cbe5618e26a20e260a202cc4cb57ff17026d0b958dfd801eb9e21ef005f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5002bde1f4c2996b20d27633b08c935fbc54f7ebaae154e07d46e4be9296c1"
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
