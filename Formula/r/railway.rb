class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.36.0.tar.gz"
  sha256 "c45eb784c44ae39799b5e45469a388c7de740b5547ab4bc05340cccc6953a082"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a161687c18c6557c04e9fd89814d8847963cfb88b1f8409a71d7399c783bcc19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11f56ee5792152d5e6d0d9fdfdaf3442caacf05457299da1761c5cd09aa73da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "300dc572ffb3126cf3dbe482cec387873123893201fbd6d9df8ee1d88c36c586"
    sha256 cellar: :any_skip_relocation, sonoma:        "8540db4dcad1905b984a7a2525ed66d10b9cefe0e41cd497397442fc3bf2aaf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bd903b8b97bffba4d8ca8b7cf6d665dd4a7c83cf08d87ed9db0928d153719ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ab9adf553d5360c58ae19a89beefdad8536ea5c3ae5fe04a531c309f4bf1b5"
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
