class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "6a645c0ff1eb01111d1256b72e153cc73be98f7d05de035d35c3b162407ba611"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ac4f1f69e3134ba6286b2e9e30af55077e68da6cc13b4ef039e19ddad21746d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ac4f1f69e3134ba6286b2e9e30af55077e68da6cc13b4ef039e19ddad21746d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac4f1f69e3134ba6286b2e9e30af55077e68da6cc13b4ef039e19ddad21746d"
    sha256 cellar: :any_skip_relocation, sonoma:        "293b9c9e83b8c1694a213506898fbf6d79fdc3ec5c3366ac19878439fcd3d510"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a3b1565db4eb1046ac395ed5fd11b040075cc0ab358589ba8d942cadd780a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e4fd4b01e17dd9abc64c84c1178194ff0ef249c5a2bc3e490158373bb782fad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
