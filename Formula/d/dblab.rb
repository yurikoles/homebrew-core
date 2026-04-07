class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "207e33ab265d2e90e1172869dca121a342b656d08b39340372ec783e8ebe1c06"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e29673b35b63f1dae4d15c9a8e3853b45a05f89cca72ca0f74fa131887cecac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee7e202bea3f55e72cdca3b1a25d97d5b3bf9e234b378e85a0e6de980db96b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff79d5553728c57075e42e035bedd6e4e91683c607df5efe65a3b0690b971548"
    sha256 cellar: :any_skip_relocation, sonoma:        "175ef434fd749296c05d8cd6b3de32e85bdd4dbef52c6c293be3958c1803e6f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7831559e3a9f162141c38996ff56087d28f3daca437692b5e44b8f9b31687782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe41f7fb568b55550086a69b752a8fd5a9cf1531157bb3cc0379c6085a39355"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
