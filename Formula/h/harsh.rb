class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "b4f03607930bc64c52e7c10e4df7e4795bdd9c840bd5a57b5607a36bfee021ab"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dca9f99419f0f2edb1591d6035293b5a0b4c1480b7b32f6dd7895f1ffa383e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dca9f99419f0f2edb1591d6035293b5a0b4c1480b7b32f6dd7895f1ffa383e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dca9f99419f0f2edb1591d6035293b5a0b4c1480b7b32f6dd7895f1ffa383e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "836ff5dc2b743b9b032864d25e1bdee23436d7a7f4ecd09b5220b3f01a8b6e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fce27d0563f62966ca018304df7e334b4715dcebea1156696d517123bef5ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add41f1a727d9ca6e52dae4f668241ad8ffed12ca3aa7d348a42dc45a9135b94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
    generate_completions_from_executable(bin/"harsh", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
