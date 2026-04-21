class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.35.1.tar.gz"
  sha256 "50a3246798c8808b7d4d78b3141d18d41363d413880ee8d663cbfa3efdde0640"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2c4d4bc15dd376e6fd86fb085a573610c66d4cd0f04b9b3291667dfaae454d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c4d4bc15dd376e6fd86fb085a573610c66d4cd0f04b9b3291667dfaae454d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c4d4bc15dd376e6fd86fb085a573610c66d4cd0f04b9b3291667dfaae454d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "498bbf40ac26cc87286b89b319935abac57b021b767bf053c76e698d4bd148db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51401474b6e1d0c51199209002f14315471dda8330957c1f6cc187316f4866a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7330d2775a0b6ed8af340812de272eeb034894533ed7107394c1112ee051f8e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
