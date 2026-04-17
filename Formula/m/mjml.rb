class Mjml < Formula
  desc "JavaScript framework that makes responsive-email easy"
  homepage "https://mjml.io"
  url "https://registry.npmjs.org/mjml/-/mjml-5.0.0.tgz"
  sha256 "635bab3caf1102035aed23d39227e6f61ab7dca561bce25adc5b0417fd047041"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6062f540813c4ba5652af74f7e52f26e7d3ffbd34e9be8cdbe4dad2b21e5459"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6b6702326a0e2ecb624451e89093d66e1fc1beb14758ea97a8016ebdb7ee4a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6b6702326a0e2ecb624451e89093d66e1fc1beb14758ea97a8016ebdb7ee4a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d168e1cfb0ef5fed2a1377f08e93f911855b690daa291e0cc65812359c64c17c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78df04184ffa0934807570025bf503003fdf00cb2a730e74860bb5ecae714e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78df04184ffa0934807570025bf503003fdf00cb2a730e74860bb5ecae714e76"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/mjml/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"input.mjml").write <<~EOS
      <mjml>
        <mj-body>
          <mj-section>
            <mj-column>
              <mj-text>
                Hello Homebrew!
              </mj-text>
            </mj-column>
          </mj-section>
        </mj-body>
      </mjml>
    EOS
    compiled_html = shell_output("#{bin}/mjml input.mjml")
    assert_match "Hello Homebrew!", compiled_html

    assert_equal <<~EOS, shell_output("#{bin}/mjml --version")
      mjml-core: #{version}
      mjml-cli: #{version}
    EOS
  end
end
