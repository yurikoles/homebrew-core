class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.111.4.tar.gz"
  sha256 "a9bff16172e782b1666c96a2812f51681370b880b0f86d061ba08f41a6b76dbe"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc2f9b7d7b5e9e2c0fcf96a78af7b990357b18d283dd795d71505c7c891acb63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a5665bf3f7f354f84c4bfb7c775c20644892d86b9d979987876174ff0ebe93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650e963399ebd459f01018c644b25aa7a7666aff0ea05f854b05aded951e69d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7499669c2bcfccb427c7fdfab460bc934dce04ee97a7838d351f2a1b8efe17bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63811da4344bfd3434e795ebe4b13ae52626874b08f382ba1ccc2ec4df1d0da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31fc01814c0b3b46bce1825691710758335b20299c4a8dc32f26e94bf8cf0889"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
