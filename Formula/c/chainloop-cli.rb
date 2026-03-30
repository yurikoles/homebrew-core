class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.4.tar.gz"
  sha256 "42e62b4642439d942032b97a94ba9e874d07132ecf8b23e839be7e94be972af0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f963e4f6be244594ab7924ab197730bed999cb5e98445a0e05571c4291abace4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e5abddb53836bda02bc92338cbc75416a1e42cf2391ba10469381dde8ae2420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b1278d5fd842a40dc7fae823efeebf709fe18e4dcff1dc7062985c6ba0b5e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e36383c89750c830502e54f5bda6dd2a7f09b4998f52d8ef874d9e93f8c878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5e9e9cbc974df19eeb9462294d7e26f48ff0ab674b840660bbaff4e73ccde8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1221b117af3ee79f62fcf8ddf3a145237b559635d06bf9fe6605b10e57b7bb20"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end
