class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.8.1.crate"
  sha256 "be0b930db736a19ee49155d625754b1cda0c6e0ffccad084080fc6b583240116"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3cdb10566295cc7dd6dbbc893e08822b322f41b9ee4d3fe129c3170ecd2c665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "088056a93ae2971a51add5850273df2a9bd805986536cd6ba7bee0e051359d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "447fa515d72ecc0356b6ea6a181e66378c6ed34f5e8d470f65cea9135ed97c0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b5716374258e055c2e0816956255c6bf900018321d3f0d5cac0a63740ae826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c63c8b6b17924238c396d91940c8d94530ffbb23feb716a56ed9e5e30ace9419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1192c64b5c012fdec7b6c974e94665436d39be9ad4f1bd30e7bed0d7674a33da"
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

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_path_exists testpath/"hello_world/target/llvm-cov/html/index.html"
  end
end
