class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.3.1.tar.gz"
  sha256 "e4b328462ca4534ccc065b2789711efacfb7eca2d0d9b951d1959373988e32e6"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1251f5712198cbacc0e31ac407dd76c4f87064b129ffcab16ea8af9176ee0eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22baf2ad3b8882ec9c977753392c8f560c796657a5d2c77d0d9de5aa629e48dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d7e23b96b7e8bc05a6ded60c80dd8ba54927530ca8c9cc5dc6e45cc411f7026"
    sha256 cellar: :any_skip_relocation, sonoma:        "a694810fc4edd8a6ff9bc9fd4bbbdbd037daf9a8fec86a24b8173dd9178c5216"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b41f250cfd8edb64153ce0ee93a84f3ff0f942a59dc5efc7bbfb8c2a942cb2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "542181f295b5306bbf34f93cb3502b55db1d0a7eb5aeea52cb55f15a3bfa3bcc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["SWIFT_DISABLE_SANDBOX"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
