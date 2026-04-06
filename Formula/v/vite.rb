class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.4.tgz"
  sha256 "881f83a5ea02519c33adb8517a6eee3c1c59e2bfd0430fdf5a8adb30823ff62a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67259327f71c1622ff697eb37f018ce1e8ed4acf181ed2df919ec92ba329adf3"
    sha256 cellar: :any,                 arm64_sequoia: "588773165445216c38f207977e2d0750d4e8bbdebeaa17d114bc7c4896d73e67"
    sha256 cellar: :any,                 arm64_sonoma:  "588773165445216c38f207977e2d0750d4e8bbdebeaa17d114bc7c4896d73e67"
    sha256 cellar: :any,                 sonoma:        "4151bd033ce6fdb91be6f8a1d7f80d3e51cd9ff319df9b93f1d68c045cf465a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95b9b9ac1030be51ea075fdd7e8f6a267fa483fb87aa437ac2fe5d71f2a1628e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f17d365758cb7a28cb59c89db46cf57ca2d21b12543db788f053b134653d510"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
