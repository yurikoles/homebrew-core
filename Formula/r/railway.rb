class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.38.0.tar.gz"
  sha256 "d76cf40fcb597434ff5981ff2c8dea0a308307fd5fcac1c572f58971c78a0b07"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5ba5edefb81817167cf88c91f0ec0f60ea1447f9826bbf21dad4940ffb47457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc21291f1234d47446bff1c077bb9f25cdee64f112b10c50d8d084dd0e55ff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75afcf86cf28870d54b5a1d505f4a8d2890c84d47e9b87793731f968e653ea60"
    sha256 cellar: :any_skip_relocation, sonoma:        "7583151a968d56b447ac09c9e202c6ec06b0ab6c59019bec0a067e8b94a861fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e916c222c76e547c4211225d1d58387f47c08d6943dc6ddbe2fca902160c07b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab35f2b1729174792f8fd39138592a8b25a3b0153cef1d87ba72a5cb26041d8b"
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
