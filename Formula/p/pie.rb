class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.3.6/pie.phar"
  sha256 "5716cf5168c075355f2129257285d69d4a11eaf7f81723bcaf15be02e2b13b90"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6b087bc46c5d6a10d2b75a0a7fe5888cd97fb5a82edd564c7a1dcfb73b1d65a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b087bc46c5d6a10d2b75a0a7fe5888cd97fb5a82edd564c7a1dcfb73b1d65a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6b087bc46c5d6a10d2b75a0a7fe5888cd97fb5a82edd564c7a1dcfb73b1d65a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fbdd4e0589382e258a09045e254adfa31f288152015c72e69a3fddbe7196634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fbdd4e0589382e258a09045e254adfa31f288152015c72e69a3fddbe7196634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fbdd4e0589382e258a09045e254adfa31f288152015c72e69a3fddbe7196634"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
