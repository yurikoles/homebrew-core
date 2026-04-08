class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://github.com/sysid/bkmr/archive/refs/tags/v7.6.0.tar.gz"
  sha256 "ff94196f04dac1e15fd9a1882a4f28a06a39295cf85a69e47d9d596193da11cc"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "122ea2a9c210fa9a52248256563a87404d6d4ba58c8a150bf0dd7eb1dc86950d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e84af3d401ed9163493721eda5ce044225272aa33ff63db262c0d1832e7b937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "953653663d697fb62000c32a2e83c64a01f9dce8a0c38d5bbe380f208b84c326"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0354aa7a0f9b7b4ecb2e3e0a72ee4e3a41bf880039d59e335e7fcc37a4980f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f56efd78c794f6918ce6e5b6ea3967cc9d55845ac69bc8b7de93bc7aaa6881d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40b493b562bbf7e5f3f4dd56501d4381ecf2922ac83e24c3212880782afd3a8d"
  end

  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args(features: "system-ort"),
             "--no-default-features"
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    expected_output = "The configured database does not exist"
    assert_match expected_output, shell_output("#{bin}/bkmr info 2>&1", 1)
  end
end
