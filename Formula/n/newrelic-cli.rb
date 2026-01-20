class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.106.14.tar.gz"
  sha256 "e9c3ce4394ae71a7e30730eaf2ad287830010626cee5cd2703f7ee9919a4c1f9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc65fbfd72bfce8d830868b127294498636820c9d48bb3c9bf8efacfb8288855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55f011a0d4fe6c41620270ba55431e0b917a1b6683e107577e546bc8f9261022"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24430663b30f0ab2aaa2cc6194f34b6d38d8b43dc46d922c1ef73b8aa45d3063"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4a6b732f9aa3ab5ec0278ff805b9d7dd127f6b253d246841ba24854bdc42570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdbdefcbcea9f83255ecf783ed97235757beca0d297d0c61d619a678da0c9670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00642eeecbe4ad4ac3e43cb6baac5002ae99a15f4159547b8d1de43124d948e0"
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
