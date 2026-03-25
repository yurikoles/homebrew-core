class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "38447db6c429b6a22888c499eb4c32ff27e19ccf174df9755d16edb74d641aa6"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45b3e50caf0212a3fe5d1590236ebfd5ec9c8b5a02fee32161ecf4ded9b9136a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b3e50caf0212a3fe5d1590236ebfd5ec9c8b5a02fee32161ecf4ded9b9136a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b3e50caf0212a3fe5d1590236ebfd5ec9c8b5a02fee32161ecf4ded9b9136a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b81bb7b518e66ca7f8ecc7971ca07d54fbc1bff34230d0b8aba89c3a9c686804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0eaae9e302a2c9702317a0443b685847f989cfb11c72db033744f35bb6f6d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d22c24b03e848553da5750109c25e368b4f813093e99820240496a2f3b2f3357"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_path_exists gabo_test/".github/workflows/lint-yaml.yaml"
  end
end
