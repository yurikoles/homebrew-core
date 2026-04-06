class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "a132788a35b26b451f79aed6a14c8f7008a74ef2863bbd432157322bf63ce4fd"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27050cc98e4e48745adbe38f4425ae54e30499590c98ab063a63e99f61e699d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c58f7f07d46d59d7d4e7b175bf8ea8ae26e9df81b484446b21457014f8b0971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8d34972494be1c6311fb69215aac4956564e2fbe64e1f2e9470eae4aa2dea00"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab396b7e6f1695be02985b78b4cb800045b897a0e06776645ee1d9aa648f096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f3a594e703dce85243f4a85f856155ce8abb4fd05932ed017aa923026f6d206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186e20d6996d74a452f6a39256a3cc30e3fe1fd04751ecac057a482b8bb6e468"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    pid = spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
