class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.0.0.tgz"
  sha256 "c27a570c86f2f347fec40d05cd62f3a58592c47fb272d106e6fa9c698b7553cb"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ddbe6209b5dbc5f55a2232d98f6ee535d844149275245d34b87e00412b38a5ea"
    sha256 cellar: :any,                 arm64_sequoia: "83dda352a8da9a74975e9cc54f7d474b9b26bf53d4f2042b6b87b02d7507c4b6"
    sha256 cellar: :any,                 arm64_sonoma:  "83dda352a8da9a74975e9cc54f7d474b9b26bf53d4f2042b6b87b02d7507c4b6"
    sha256 cellar: :any,                 sonoma:        "a04f656785f5afd05b931ac737597baa17421e7ef8a663cd4bd246f8a213a1b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edc8b74cda8478b2f6332056d8e9cda75b5ed20fe7ad7d381adb0edbd64cc4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7366998cb2e15a11f131716dd25cbbc1473740d011a0b8d9954eb3b177446dc"
  end

  depends_on "node"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    modules = %w[
      bare-fs
      bare-os
      bare-url
      bcrypt
      lzma-native
      mountutils
      xxhash-addon
    ]
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{#{modules.join(",")}}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
