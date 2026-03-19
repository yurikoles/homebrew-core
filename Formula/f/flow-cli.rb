class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "4e5648acda8e653306efbc715a646cbe2c47fa2974cc5d7ccc5ca9581a7fed24"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d26e4ca04464ac48cdb9b792f4592119260ea0ba12d7cf8f9bab35a0597e2f14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70cde2c3e21e10dea977db25181270fadd660ce57fc0becb9f249c605ee14578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf5924e95d043e3929c635195d3377ac862414bcc9eca147ae3979cd2b7e8d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e7da86c5dff858be6bac74548c392f76559407a5e6cf2a58242339009a3cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7277403717bfc17bdc065cece931e34208628adb898c8a806914c5d4176ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e52a6697d517bd655563991bcdec67d636252d93bc4269c3fc35fe849c72ed"
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
