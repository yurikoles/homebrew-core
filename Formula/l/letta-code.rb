class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.18.0.tgz"
  sha256 "3e6ba10ee6686ca31cf420a799039e677f98996a0847c9c34f1faf55632af9c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "175cbc1cd51e0840f54d13d97af5b88481b8059b1af5579713e1e0f303e28126"
    sha256 cellar: :any,                 arm64_sequoia: "194b9293c23c257c47f16a86dbe60f71c5e19db8cae4f4da91ecfdebd43e42fa"
    sha256 cellar: :any,                 arm64_sonoma:  "194b9293c23c257c47f16a86dbe60f71c5e19db8cae4f4da91ecfdebd43e42fa"
    sha256 cellar: :any,                 sonoma:        "ada44d74a020d085e6c3990d94079b724351bceb3c8717996d2d71071b940ee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6726378617b155bdb0ef6022ba6048459d853e54033ab910d9624da2d94220d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093e6a14f7eb9d865c4d202dc68d3c8b9c9a913c1506f16a7572a8034273504e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
