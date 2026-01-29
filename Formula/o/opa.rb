class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "24cc7bfc1b83180462b574f941790b8926a8a632b7b5fe29c1646165f3ef3c32"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22453071df85d0a2236da7645cc2e6fae18038349e826378cabeaa2bec180d9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7d07c2eee41f3f0b9b42618008379aad4a02f9b3fd0cc0f940ca50d7f0eb795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ffc22d81f59810d3e8550205ff49e55fcaee8d8e85d16fa732f888003962e50"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae5fd6ce6dcf6b29fe48ec793b76f4ec7fd3e3efbc74bbc60a62bb2fc8d2f1de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b78856d44099102550096611ae01e20cfd0fe4e4743512ac40e61a33599003af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3dea8763704298c96e0650e9fcdafa573d296f6fd6e5c10b68ebbf2207d23be"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
