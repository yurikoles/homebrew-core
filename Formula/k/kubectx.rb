class Kubectx < Formula
  desc "Tool that can switch between kubectl contexts easily and create aliases"
  homepage "https://github.com/ahmetb/kubectx"
  url "https://github.com/ahmetb/kubectx/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "efcedc14a1cb7e4d0c9b0e8b50fbecf5a24b337f8df7b018fb70a50420fcd27a"
  license "Apache-2.0"
  head "https://github.com/ahmetb/kubectx.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectx"), "./cmd/kubectx"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubens"), "./cmd/kubens"

    ln_s bin/"kubectx", bin/"kubectl-ctx"
    ln_s bin/"kubens", bin/"kubectl-ns"

    %w[kubectx kubens].each do |cmd|
      bash_completion.install "completion/#{cmd}.bash" => cmd.to_s
      zsh_completion.install "completion/_#{cmd}.zsh" => "_#{cmd}"
      fish_completion.install "completion/#{cmd}.fish"
    end
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/kubectx -h 2>&1")
    assert_match "USAGE:", shell_output("#{bin}/kubens -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/kubectx -V")
    assert_match version.to_s, shell_output("#{bin}/kubens -V")
  end
end
