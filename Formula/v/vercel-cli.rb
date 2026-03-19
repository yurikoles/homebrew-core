class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.34.2.tgz"
  sha256 "b05e4cf54c6884fe8707cd87d7eaca08c4b6eafe12604202dbd52b44ae012342"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08f12d73fc6f27f54a597e9fc6e3b70ee3cac64261997c91d78b51761ea6948c"
    sha256 cellar: :any,                 arm64_sequoia: "bd6a034e194e085166908bd7bebdced3855344ac8a8cacc75542c762585a194b"
    sha256 cellar: :any,                 arm64_sonoma:  "bd6a034e194e085166908bd7bebdced3855344ac8a8cacc75542c762585a194b"
    sha256 cellar: :any,                 sonoma:        "50d82430de17ada9378b7bde6dbbe138b65bb4079fa5a4c554b863a37b73adfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe9cd97ec33994f86bfc5dcd1d6e61d7ded143cfb965233bd1019f43bae51e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03387896d2c9868b0afb587f7f865e4e0304296fde4b90549cf9c343f034b2f2"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
