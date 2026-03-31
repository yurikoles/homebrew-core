class Edgevpn < Formula
  desc "Immutable, decentralized, statically built p2p VPN"
  homepage "https://mudler.github.io/edgevpn"
  url "https://github.com/mudler/edgevpn/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "3776af1f342a848e69687e14806cf5fa2597ab67679a2cec853955e255839106"
  license "Apache-2.0"
  head "https://github.com/mudler/edgevpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "140d51bd4aac6e70cece4e376085099b242969a3b2f4bcbea39fa74a151fc429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140d51bd4aac6e70cece4e376085099b242969a3b2f4bcbea39fa74a151fc429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "140d51bd4aac6e70cece4e376085099b242969a3b2f4bcbea39fa74a151fc429"
    sha256 cellar: :any_skip_relocation, sonoma:        "76aa37e638cfd62b4f2862e9188bc9674ef83e6b0fcd4befd9f427d817cbaa8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7bbd36282594f56162bc72bf03629a65b81f33cb4f69f56463a197b22ddaacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8b82bbcb4cb363948814e9455dfbb38488fedb251a01ba1dc1dd7b635e3f92a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mudler/edgevpn/internal.Version=#{version}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    generate_token_output = pipe_output("#{bin}/edgevpn -g")
    assert_match "otp:", generate_token_output
    assert_match "max_message_size: 20971520", generate_token_output
  end
end
