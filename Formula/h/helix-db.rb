class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "2c98fc6d718dd0e6ca773e18c71d2c9e18dda538550278624fb90f38672a0d73"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f5959304ca7ef89cae7501f85c386bd3a8e8d3a010954297cb8ec2f93910e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95b09b497ec8191e88f575c32fbacdb9055148ed6dcf1b122033ce3406d4e09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ee04d806a07d09b4363779c51b67d208404530ea3215f9926a0f3472d07a2ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd94db8f06d6a8632f53190301e8cfa301c91c4adae28bc0abd64d9f79da98a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d485a740b571567deaae5e426e6b84580c23d9fb14b1c4b5d98c2290cb3e419c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafd86590cf436b6f238a7e2500227b321f1cd130c0b2a7b251ccdc4b6c58d12"
  end

  depends_on "rust"
  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    assert_match "Initializing Helix project", shell_output("#{bin}/helix init")
    assert_path_exists testpath/"helix.toml"
    assert_path_exists testpath/"db"
    assert_path_exists testpath/"db/queries.hx"
    assert_path_exists testpath/"db/schema.hx"

    assert_match "SUCCESS", shell_output("#{bin}/helix add local 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local 2>&1", 1)

    (testpath/"db/schema.hx ").write "N::User { name: String }"
    assert_match "error: helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
