class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.62.2.tar.gz"
  sha256 "b49681282bd9ab376d3f250cad53f1356f7004763c39aa41255ec1c263b05673"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36c6d8a92634b47518c08ebd461d086f26494a4bb16bd8cfb2a257705a79ee83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d298ace443c6eb5c004a78328e9cf7effe6b5c2acf0d40aeb0d1b46c3b926b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8932cd5f1d186457d31d0c3f3917ff75c58247c2d668735338d6ae3deb4b0b63"
    sha256 cellar: :any_skip_relocation, sonoma:        "6908e98319b36f7e9222fd652252a6f539f8eca3eb4380a8e762cd9864ab3264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c37a573b610c6dfa2a1abe380a2afbfc79eb23d96c6136b37015f065e1c914ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb6e14411262259f4748a2fd950fc452748659c13aa8609c3fe1a387a85ad2b5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", shell_parameter_format: :cobra)
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
