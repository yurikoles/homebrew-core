class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://github.com/Checkmarx/2ms/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "0e5deedc20c51f21d5b044dc0d30e086ce2957d9c8050c6fd4db5da9ba852ae2"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaba9522a28b46317b3dafe377a41b45500ad03468e9933f7180b01b662a4d27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12c61d2f903d651162845c9bbe6d1ad796899a16571fbf2eb5187b167a32677a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31888c523bfc816f4d7a166cb9008f7c8a2bb23ff2cd34a252f326f65eea5d3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "926181de6ee03a4d51bcb5178ebaae8810b27712607d40a11345737538cf9f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26d49edffbee556b276fc5898b825021611bae96204068f5a2458805565c4347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd987a874113cb43c418a11eab22e6e8ff4da08c0172a13d9c1fa68f38b65b19"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"2ms"), "main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/2ms --version")

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end
