class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.7.tar.gz"
  sha256 "1f014c195152c80808bbb921df0f31fb36d8bf32c93cf2e9a0dc112d58a7b899"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5413c6aefb77c7c98bb35ef1f7ae2023c46076546d6937889488b9e74cd7ceac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5413c6aefb77c7c98bb35ef1f7ae2023c46076546d6937889488b9e74cd7ceac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5413c6aefb77c7c98bb35ef1f7ae2023c46076546d6937889488b9e74cd7ceac"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa749131b085cb58c0097a45f31f0bf046fd5c793c9fc6a958ea2b76c5ab397d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c465c2b81bc86cff576fb0ab5dbc012bd96178a798510cd90a011210084f70c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "392a2f9925e6a62e8ec91c3598e469ca00f4cc026314c08a7337e3052bd00259"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
