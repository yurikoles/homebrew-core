class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.3.0.tgz"
  sha256 "7e0245e638db3b494aa5e4c49c359688fe6a0cabe7dbe2d6c28fd730582e8e6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c823c39cb64d2319000d891886d0436db5d0bca35b92c0573c5966f77faa3b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c823c39cb64d2319000d891886d0436db5d0bca35b92c0573c5966f77faa3b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c823c39cb64d2319000d891886d0436db5d0bca35b92c0573c5966f77faa3b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f713c729e969bb162def6e0aaa2eac5b4cf13e39860d8841ec978d1c8eb12a02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f713c729e969bb162def6e0aaa2eac5b4cf13e39860d8841ec978d1c8eb12a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f713c729e969bb162def6e0aaa2eac5b4cf13e39860d8841ec978d1c8eb12a02"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end
