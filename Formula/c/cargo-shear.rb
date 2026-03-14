class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "1488c81453f2d5af77a25fac86933a3a780237592a8286747bd1c89018ac515d"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0231b1c62c61830f6b9c5bdeb601145636c7bc5197619b6bf121ca57a8b69c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc02907c5a98eb48eb39cd2faa4357464901b5c24234662a6acb9d5371d15a14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fa0a81ea41ebf10ee862819b739f2a86dfdd402eab169fc6227b784c7a3ec8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a45e9e4ace1adfeebf8cb5601e42ac8ce77b565eece9e4c1f1bf05135f99d249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c742ba435119292ecee2ada9e737bcd457607706d5e1c77b535c97ffd03cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828d4ece1585dbdbb373df570b2a998170be45aa175e609a0d254d0811f1a899"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end
