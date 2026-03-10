class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.23.3.tar.gz"
  sha256 "5d1aa6e09862d86aa86564e2f9635f1f0afd48a332ab831bd530b47a4c7e6be9"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ff9e7da8442d358c77b460be046bfd22ebe21f64f23033697e8c7e2089db55e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ff9e7da8442d358c77b460be046bfd22ebe21f64f23033697e8c7e2089db55e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ff9e7da8442d358c77b460be046bfd22ebe21f64f23033697e8c7e2089db55e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b639a30ecdc82504f74893189fb66043c7cddffb561a3da88925e9bc188c4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "157b51a78513cb7d17b768f5a45507e13bdacf27446f5ccbe57ab6baf4730c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa57057cee16741142bc83f233031bab6cc4da8f577dc3c91e360f334b298d11"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"

    generate_completions_from_executable(bin/"pluto", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end
