class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "a6e994274f34d4316e7ab797816e585a01131fcbed970bff9bea2a0262ba590b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e8440379ca40172d6332a128fc199e707356083c79af13cdb59dd0e1a071ec8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ca806289a3ae033d2938b50f257faa9f0514f3d92ce213fd1988bf55cd23ae4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93464774235c6e45aa5a5087cd4b54075785e0fd63e31dff349df57abcf3debf"
    sha256 cellar: :any_skip_relocation, sonoma:        "37f497158c1cb8404b7ecc95122f6b27a6fd0ac50a5b47e0aba04eaa00c916fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "916eff7c5a2753a3ee9570ef19b5a7afacf16268e1037729edc29e9524eb5bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eb4b84da6d5715578dc268f42d4b03305261cb1863f48926b9e7eaa865d34ad"
  end

  depends_on "go@1.25" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
