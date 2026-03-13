class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "6a8e521b466b63b3c25d78b1e72662b548babe15423061c691c7039b2e0c03d4"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ae655f2a7629f0db7e62957072198d32c38ba787bff994deb268b02c23aee28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84f50ce6c7db7a5f3004457ef3ba7ee4efa1c4f07867a92b16ac959ee07624b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2403fcb35263e600e20dc40f1d207bd4be2f5295949f40ec5b61c7c6646469"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3158fdf4272ff2c5ad8e47342ac481e508cffa084adc95b26e04f15dee13e94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07df6e45a31e4d664588e1447bbe1d8af91a71d146c99a99cb2cce9ec25704b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3fa22284f633a2ee78c2c7f003d2cfa64f4a5641f221d5472e6fd57188660f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
