class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://github.com/garden-rs/garden"
  url "https://github.com/garden-rs/garden/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "a172077d817eda235f6e91a894a892485c2b19a8313eb60abf7c550258676125"
  license "MIT"
  head "https://github.com/garden-rs/garden.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b5e7d21549c7d8fe7152fac5ec8438b60123d8b3d0d35b30c26ecb5ffd50bca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b405cc9b0a0b70478e5ae3971703cfc31ca8680c6d945d2fa6d7102c2a64b21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "268044e3af3645e4fe5fd3c4333c6be80bc8b4306afd4f95fa4603aa0fdaa8a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a9bef45553925aa15ee08537137ca7e6536dd608399fa3c22db14b90891eeee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe16cada7d3927a81b1c277bef948344edd9dcc58131e2496b6750977925427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "362052def31376f64ea1cb0c199aaad742a4b2563799d561f140f6a0d93bdfbf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "gui")
  end

  test do
    (testpath/"garden.yaml").write <<~EOS
      trees:
        current:
          path: ${GARDEN_CONFIG_DIR}
          commands:
            test: touch ${TREE_NAME}
      commands:
        test: touch ${filename}
      variables:
        filename: $ echo output
    EOS
    system bin/"garden", "-vv", "test", "current"
    assert_path_exists testpath/"current"
    assert_path_exists testpath/"output"
  end
end
