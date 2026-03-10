class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.23.1.tar.gz"
  sha256 "d9f512a9bf4c0bf55b446a180eb728afab7b76ea4827dd33f2bc3f2d221a1aed"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9352ba0e9d98ac10a005813c4948f1b5029a803c77deba5fd31ffe1951f354c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9352ba0e9d98ac10a005813c4948f1b5029a803c77deba5fd31ffe1951f354c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9352ba0e9d98ac10a005813c4948f1b5029a803c77deba5fd31ffe1951f354c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "340d4248fda9206f639b4ab439b69471244326efaf94a045926953c3efee8172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9aabc16731d0b859c92b2f2a6ed1a8759f5a7a4a3ad955924bc08881bcf9d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a9aa5069ed3c393c05c6ae6d6d2778380f41ee73ffd07735badd8548a07a98f"
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
