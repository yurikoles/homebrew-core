class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "fe86ab82fb857207873ad992a77ffec491dbbabe29cf1b64ac1a096ff84cd9b6"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/kubectl-ai"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2a67423eb2cd82deeb3dc7a19e7b9d2077c3e301611778c23c115b7f8e1ad07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2a67423eb2cd82deeb3dc7a19e7b9d2077c3e301611778c23c115b7f8e1ad07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a67423eb2cd82deeb3dc7a19e7b9d2077c3e301611778c23c115b7f8e1ad07"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e2319c962f2017bff56b7ba9aa413f0fb4ea21a43445401dbe5fe72f237971"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c20c658418c707f535a2197695b7e9117fd6584e6cb6a1da0e071ebd529e40e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f6c086aa37afc23548ace865384d2d1261a069cdf6af56a96b284755f72095b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubectl-ai", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-ai version")

    ENV["GEMINI_API_KEY"] = "test"
    PTY.spawn(bin/"kubectl-ai", "--llm-provider", "gemini") do |r, w, pid|
      sleep 1
      w.puts "test"
      sleep 1
      output = r.read_nonblock(1024)
      assert_match "API key not valid", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end
