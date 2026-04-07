class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-24.1.1.tgz"
  sha256 "c0bb03b1e6d539e6ddad8c7ad8615dc3dcaae33ec6872826d409ce3e073df4bb"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d4e74c4c7f82f37ed0bc4417cdaf4f7449f1ea367ccec8c5f0a13f04585ca1e"
    sha256 cellar: :any,                 arm64_sequoia: "7742e5eb58bf7e4e17a992d2195549b1ff5fd6ede271c306ec628cc969782956"
    sha256 cellar: :any,                 arm64_sonoma:  "7742e5eb58bf7e4e17a992d2195549b1ff5fd6ede271c306ec628cc969782956"
    sha256 cellar: :any,                 sonoma:        "53c3ecdf797f2c4c538d3db1a948da90d831d3582a3224c0597ecc562fdd806b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "050b5be6711b54a5018551bac36c7966317e357abaac6119cfc5f5eb8083077f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0080e0369d6a68bac703d7554c76590d7b7724e3ea52d81ebc983c2816f36dd6"
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
