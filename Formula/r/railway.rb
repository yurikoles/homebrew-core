class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.40.1.tar.gz"
  sha256 "9fa556abad3b64f3139c90c5f33dced2f2ecd47db8c3e0fe5f41c43efbd2e087"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5634506fe84f9540e356d7a499db1b2b0a84637095f280639edae11fa1b357d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc72e5c4cb843fe059d941b8ab89d6b432945556824d53d1026942110d3c106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64824a9e5fa6e668c239581b8b6c8d7b8bc96fa15f54e68e47db4771c4f50209"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab7cfe8994ed3b60aa801e824ed7e033b4524cda7299263859464dd7d54d3e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "619338bf136d4f4e3d41f048bcab7ae6401ef3b682cbde2e322f3506e70b6d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6ebf998f060cb7b89871a55f67ebccffcd23cc2a93424a1f07eff0873258951"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
