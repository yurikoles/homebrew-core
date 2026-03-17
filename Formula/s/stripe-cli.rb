class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.37.5.tar.gz"
  sha256 "e47127548a4d86f32b7af942dcc87b78d1aa83e40a04529c82cefb085bc6e34c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f91d172f3358ae95453002cb38a291f55755ec32fc41c8c41cdcd7bf66ce0a1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59509a25e54a5bce0a1b4a8a458bac35fae810e63977516dabb5b4d28ff0fb98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90a4c40be2f2ef4126e6e0ff377258c4268ebe5ffce17073aab9b0e994379996"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b3ea50bd2e4dfabab9dbd9230666be63625de1ce1eb7b2f9de9b8e6bd82f23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c4a6a88c71553ce181e8323976e4620f0d9d598b559a2b1aec1b1e575aba6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d76c1841bf6b4894d59a9cbd67da06ecc28064530fa6abb0f8fcadab696f0590"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https://github.com/stripe/stripe-cli/pull/1282
  patch do
    url "https://github.com/stripe/stripe-cli/commit/de62a98881671ce83973e1b696d3a7ea820b8d0e.patch?full_index=1"
    sha256 "2b30ee04680e16b5648495e2fe93db3362931cf7151b1daa1f7e95023b690db8"
  end

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end
