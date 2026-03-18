class Pdfrip < Formula
  desc "Multi-threaded PDF password cracking utility"
  homepage "https://github.com/mufeedvh/pdfrip"
  url "https://github.com/mufeedvh/pdfrip/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "e75bb5bcc2b58f80189dd10ba18e3cb8673935316172b8bd7a63822859cba11b"
  license "MIT"
  head "https://github.com/mufeedvh/pdfrip.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1036db7676a0822b721390e43e797e7e846dbd3b4f0c35acc3fb71fee338f938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c75d4a427d4512dce141506acc4d3b02e8640d3fb54a30bfc0c9be4ffa525a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeac32a01baca1d879c37adc93518653405ffc1437ef2551eed0d7bee45a9c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "b27b773f78bba7b8d64b60cc5c8b8cdef12d45574be2d4881223bace41d64acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0db2c8b883091a68cdda3fe1f4da41213bd041fbe8b93862b86e744baa60c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8fc88b6d291c32c7e3b0ed9fdda602f2a237e8478921f07b56bf550dbcbbde"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfrip --version")

    output = shell_output("#{bin}/pdfrip -f #{test_fixtures("test.pdf")} range 1 5 2>&1", 1)
    assert_match "PDF is not encrypted with the Standard password-based security handler", output
  end
end
