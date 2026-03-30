class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/2.8.2.tar.gz"
  sha256 "0f74f11c21f6291479bbd08a924d091bd84e66de68d3ab26293d5c4aa3530221"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9934f926b81a35a0cd03ab77fba5d9b4200714fb1d510ae26193ed27b92c7b4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c81bca7a4c39c6d7902b7cb7026c9f601aa0ffba37c86194f5babecb283852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9259eff716c09c51479e39825e8053a50d021e7880a7d0098500c1978d3fef8"
    sha256 cellar: :any_skip_relocation, sonoma:        "25b4d4e6159da95f7e23bf538d40753235560fc2b7db4a5ddc4f03bccbacffa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76820dd0450539adb78a8be372bd85ecdb18e664b32d9cb0502b1f3e6e11a5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f2161edc49d20fd6e2ec4a8fcb103226218d55d93587d43a2a8402d1c75b452"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get testworkflow 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
