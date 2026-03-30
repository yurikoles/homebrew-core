class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "8185e9b9ff246f6a4da40a00a4d8e912ad393908eb8a0e2e3d0fd494c40cf918"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf7d035b3885f5e27becf72887cad84d8fa60397584f7d2dca6c3315559a34e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "952d98ffce3c8bffde3f469873e0c704e8e4ad01c5cbc70e8b8ddf8bd8a31c0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac42f41238c91337a362e469262ef6dfc785f0ffe52f3d3308c59a52de54626c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d09a9ccd79660ccc72514f991f4768b05bd6c5b1da33e7aafffc7aaf72c9da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713680944984faeeee5d56ea3cba4c9a48305c8b5ab936bc29a8f3d7bbe70d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfbc95b9b23c9875860f2f3a106d779778571c1eef058a9df124ddba77133817"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    # TODO: see if fish support is added, ref: https://github.com/stripe/stripe-cli/pull/1282
    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell",
                                         shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end
