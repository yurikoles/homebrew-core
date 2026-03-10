class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.108.0.tar.gz"
  sha256 "3bdbc892396f62b8e4094759f20cb3dc4fb105b5a1ddf2854823f5188b9e1d92"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45210f4bcca41f1584d050d9046114bdae2b23f5f014c76da093f5fd051a3f35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f69da8fe4be08f181d930e65dc6e513bc6135c6908ada742e4fff00b8e337ad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0798808963e3e4a22d7666cd951b27c4f3f4aa932c2552b63b5ead4239cb344a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb679e47aeab7cdfbf6ee01723f2107323cfd59c3990d7b29f3e140b32d22c1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4d2b03f8578555c081e862867484e6dcdbc94d1b8390726b41d1c0b2d4df12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab24390c9847f4180715c3b70fbdcbb8af7973e4ca23895b0c8ebf578d19312"
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
