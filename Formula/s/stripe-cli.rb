class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.37.4.tar.gz"
  sha256 "7185145d11ce473ff68d24c0cd4efa4a4e0e75f783bf98f2bf4cac2f9876ce91"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ffeb3b14c0240565dbb1b60ecc19296ca677a6d0022f2ae4781b3f6660523b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21862fe190f0ac3986ce7aad95de718c8b229921c24b3acee590f64455f133bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3082399a9bc2576912e43f4f05d10363badd722ea55bddeaca8724e002735eca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f504fbdcfabdea227fe0b047ce94fbed2976a8fd5fb412747bdbe9b14426fa0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abe2dd1e9a6616c64843221ef454c8c864a7a7cad29fab23cb3bb81c2a58a17d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55bbf3d16f797832891612e22daf9b2ec5e97be7e45eff3f9c8a15f75fa6ca18"
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
