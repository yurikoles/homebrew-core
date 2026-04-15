class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.14.1.tar.gz"
  sha256 "644a6008a46c7ab837da7a70c89f913914d9fe578f9d5eb9307acabfa8548107"
  license "Apache-2.0"
  head "https://github.com/kubetail-org/kubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0005db502fde1a3aba24b26d0a4f090896386f321d74a219fae85044c5c5368d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07bb72258f3513573668f2f32738ee1696df9f7693f71a4af36a2859044430bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96cfe4efd15098ee28f6b211c0fcffe68a99d50b43b68f84c17c511ff90e662a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5adddcb3f33a396fc5f66b4f315d4674f8627e26d80c1bfedd700177b2ddc9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83680610866388b66a4771b1a78ce364bbc96b00d2cddb2c04068d6c36a95cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db36e35524321dbe7d868cbf2bc8c51a75629633895a0e360792bffbb56e08d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", shell_parameter_format: :cobra)
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
