class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-10.33.2.tgz"
  sha256 "7a7bcf13d7f6ceb3946c03978373d99be9fde1cafc3000bdfed4c4f791167610"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-10"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e36a7b63d317cbd82d4dfe305d60e4e9d2d1dc426934e6885a0f80a7cb14359"
    sha256 cellar: :any,                 arm64_sequoia: "2394b8bf001c69ec8ec6bf6852167a354e7802f89cd24637ba3765471e39b02b"
    sha256 cellar: :any,                 arm64_sonoma:  "2394b8bf001c69ec8ec6bf6852167a354e7802f89cd24637ba3765471e39b02b"
    sha256 cellar: :any,                 sonoma:        "31d48b1ba823fa31a309fa6cc7c6cfd439f7a472c1b90a9d7aadfb84286ba694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4108822975e9684db3f3bd27386524dd595c8bacab1f00bdb2e7fa649c51483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4108822975e9684db3f3bd27386524dd595c8bacab1f00bdb2e7fa649c51483"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
