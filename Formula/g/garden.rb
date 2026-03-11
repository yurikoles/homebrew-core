class Garden < Formula
  desc "Grow and cultivate collections of Git trees"
  homepage "https://github.com/garden-rs/garden"
  url "https://github.com/garden-rs/garden/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "a6b43da40aa30b63e88dc26da902f5249c939f67536b524f2428f3c3ae974cc8"
  license "MIT"
  head "https://github.com/garden-rs/garden.git", branch: "main"

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
