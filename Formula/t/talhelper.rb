class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.8.tar.gz"
  sha256 "0deec62eecc5cffc28f75fe27c735edacbf37ceb81838db59653b205257072b0"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b889e45e1c4908985a6fe8a67ec51c511be9b9f00ee71a2ceb1e5ff9dd8392ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b889e45e1c4908985a6fe8a67ec51c511be9b9f00ee71a2ceb1e5ff9dd8392ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b889e45e1c4908985a6fe8a67ec51c511be9b9f00ee71a2ceb1e5ff9dd8392ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "03dbf9d9cc37a137551897d9cdc57453f89f872d0d8ca4392a17638d772dfb7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55be0c2fb8da77dc2cf96df87dff1861a210b7e3985691a4ee6585b11d9909f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "847f7edf0c7eb880246071c34d075bf8d485befe271a9b172a6ec32f9e515187"
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
