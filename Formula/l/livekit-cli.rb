class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.16.2.tar.gz"
  sha256 "8c4893a34d212f7a294923261ff4bd72a2ec2e64caa85278654ef2a833833f28"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1974143628830bcdd058607982012efdcf4544299934ca1778537a4843a2b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f104e911632e18fd33d633ab57d2b80a485bfe886321edbd6752d7147c1956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "184c021078aac845472eda72930123d85cc2d922f8eb34cc9d2b658a0f03e8ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "918616c9673fddd93df077377869a4d1cc95b3c08a31cc6966c2e94480b331d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e3f449cdc53152adca122981c062b1fce4d573479d77f8c647a507e904acb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b46482123ad3597d6d26a3f3b670029ce0554ce6137631d3af03998e936dce18"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
