class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.18.tar.gz"
  sha256 "5943262b891935c2f6cd1f70da22e44d1a7b0968d026ad84a5c0f4df6eb3cb9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d1bc7164d430540a5fb529a711322d13e7bc4f062b1c9901f1e001c1a434fd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9ea80fabdca86fc7f41018904b4c9dccf55b7ec13845cfc0cc3e7bb8763d8f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ca61824ac0a47c8b3a0bbeda269692e41d692e90e6c54fa84589a2127e5ec3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e475e9a0f7b06da664c0c3f6d39ef5c94d4b55c99a0fdd62b9edb1e163aa5d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2929ee1e809d69ffb26cfede517068aac2dd676e8672dffe87e5d3a70e663f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44db0cc78d3c97818fd560c3b7ce70458f0d9963824be17cb8f70406e4a46eb7"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
