class Firefoxpwa < Formula
  desc "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox"
  homepage "https://pwasforfirefox.filips.si/"
  url "https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "a6956631ba62442d108cddfd8139d69d39f47004e8d36390a042ab8580d08021"
  license "MPL-2.0"
  head "https://github.com/filips123/PWAsForFirefox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86e5d3547f940b29a965973b980a24a2a85d06036952259532d0eee2a5932999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef43e72206d48c37f805b26dda092ade5d150c579e62cdff4c6400c76644007e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47d2cd25df696836399017ddafbb37bd50b5470718527e8b8990717f50411c00"
    sha256 cellar: :any_skip_relocation, sonoma:        "6396b0df425dbe2db17b8278f5bedb98f7a40e4e73e487be7c47f39588a931a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98feb86d5b3ec607c7d9151b8a3590b952f9496d76336716b66d85c26ab3d33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac5d086e379b7888b1cb2a9d5f9f32be2033c12c0b966e1c55e27ba3c1fc2e4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "bzip2" # not used on macOS
    depends_on "openssl@3"
  end

  def install
    cd "native"

    # Prepare the project to work with Homebrew
    ENV["FFPWA_EXECUTABLES"] = opt_bin
    ENV["FFPWA_SYSDATA"] = opt_share
    system "bash", "./packages/brew/configure.sh", version.to_s, opt_bin, opt_libexec

    # Build and install the project
    system "cargo", "install", *std_cargo_args

    # Install all files
    libexec.install bin/"firefoxpwa-connector"
    share.install "manifests/brew.json" => "firefoxpwa.json"
    share.install "userchrome/"
    bash_completion.install "target/release/completions/firefoxpwa.bash" => "firefoxpwa"
    fish_completion.install "target/release/completions/firefoxpwa.fish"
    zsh_completion.install "target/release/completions/_firefoxpwa"
  end

  def caveats
    filename = "firefoxpwa.json"

    source = opt_share
    destination = "/Library/Application Support/Mozilla/NativeMessagingHosts"

    on_linux do
      destination = "/usr/lib/mozilla/native-messaging-hosts"
    end

    <<~EOS
      To use the browser extension, manually link the app manifest with:
        sudo mkdir -p "#{destination}"
        sudo ln -sf "#{source}/#{filename}" "#{destination}/#{filename}"
    EOS
  end

  test do
    assert_match "firefoxpwa #{version}", shell_output("#{bin}/firefoxpwa --version")

    # Test launching non-existing site which should fail
    output = shell_output("#{bin}/firefoxpwa site launch 00000000000000000000000000 2>&1", 1)
    assert_includes output, "Web app does not exist"
  end
end
