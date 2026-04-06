class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "8503d4b41bb378c752ad03cbd6d0a9f58f3eb43c97df8db46db74004267d17c4"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "706b4c79f6b2a2f8189de18993ed6ef5cc8ca1f040f309b6dadc9438fb4864ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f8753696f1e97fc78888899b32b50ec7dbc14b15e7e6a203615c42e3c977bec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eea2fe37b3e931b66a362adb475630e28894023df6f767086c84550995817517"
    sha256 cellar: :any_skip_relocation, sonoma:        "7326d3673a015e7124457cba64c69fd88fdfdb91aeafacad73619bd0c7deee6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9faba2f45d1b82dfb07497fb825564192b530a65e8609211be7edbe31f91d6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a40eec45a220661fbca44d9c0c95c9e5e76f7533df48063548d52e27403750b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/app/commands.version=#{version}
      -X github.com/kriuchkov/tock/internal/app/commands.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/app/commands.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
