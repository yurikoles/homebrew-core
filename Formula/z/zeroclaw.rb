class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "8c968abb87fbcc99b57855cb66023d29623d7348190cde0b04772c27e80b949f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2c32d60c58cccbc0b620fa90b077253df0da029b720b95b0b965992b546d54f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045188e128420162ece73bf496860fa7c2c537ba7482444fb13ad2ff3130e27a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b378d58917cd103761a217c08c14c4c68273f9beb995a12eb7adcee410b709a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b11f88a7ba3bda4cb789d7e40cfb29c307f1a6a967f61bb4cd242c6de7d4d146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87a9b2cc8fdc68b57c2da90dd14ffe40ee11490c470217032c0bee2a5c0b91d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5606a6c22d7f4763e9d4bbe99a5f318bcc33ce6a9af223a09dcb9922bd4045"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
