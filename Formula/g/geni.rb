class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "5530fb7fff8cfeaecaebe95c0d68b93a757369997872ed48d30d8d2f3625992f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33b7e90913184369b38ea456945dbec1b1450cdc6d01a5d4a578b9449b42680c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bca8943ee42eb25d5adc701d1989f084d66cf9604f30f328926df528bc1cc1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a1217e1065be5dcf77699bf6358f722b5fba8b4a01bb10f2f14d0149d1db35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "704a0e9e74c396ea872554b17896e6e3f43df65bc5320e7b4709bf5334c491cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0740ce9b9e0645dccb090610bcda606587c0b80d100bc9e63376662a2191bb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88374d6d9dec3c78b67259ede451dda7a84bd0f5ae710ef8528bfba92669ad8f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_path_exists testpath/"test.sqlite", "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end
