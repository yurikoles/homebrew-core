class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "929241d33d4cb21c462374aec0b6630ad3cc194d5367d5f0cee83136e1b59771"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89fbc1c1295be9d94fdd20d5dc0ff36323c0545a6894a74f72a4fb1ba2084eff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd8fe82617c0e626ed3adeea7155bedecc4b52de630a3c71876ae161ea2728e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94392047d87d5811e60c12f42d7952d30785be4d8dc476dc5e7f9ad688ff97df"
    sha256 cellar: :any_skip_relocation, sonoma:        "2722c3cb6a2246847869723ba560ca9c6cc73e4ad7a9d4a450ad06c06bdcc3e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dc580b9ce05ded9029f778c688414e454b19a9a3c43db56b421c997e6f3684c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c7396dc341ff2de6288ca5213221467c13d7ec5bb64e7e668d963cf3ec526d"
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
