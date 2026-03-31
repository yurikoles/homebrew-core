class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.3.10.tgz"
  sha256 "5e266285a1d65e4ccb3bbc8d9e62cec2b0a3b9cec2fd11b5877bbe050064f7db"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "4cccb903b652766dec737814c854584e115ffe0810b7d3ee568f6318185f610e"
    sha256                               arm64_sequoia: "4cccb903b652766dec737814c854584e115ffe0810b7d3ee568f6318185f610e"
    sha256                               arm64_sonoma:  "4cccb903b652766dec737814c854584e115ffe0810b7d3ee568f6318185f610e"
    sha256 cellar: :any_skip_relocation, sonoma:        "774fb9cd3f067e9bde8e108f7cf8588e9c14cb786447b47458e9a3a37b1023d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7e1b80db1619ceb21b49c2be009f56ac7471d942f7f673e216fb78bbe3d9a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c276dd02101b039c6ede2ed2c15d6cc32cd29c88712c3bb6e05d26ab05365b2"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
