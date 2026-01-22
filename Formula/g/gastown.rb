class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "690ba9f7e70544ee101cda38d57fd79d1e614f4241a39b253ffdf1ea125cdc1e"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e2c85b3f06606af99cb3e0edbb0af9c5d47b4171b2f598f7492c1312f1c397e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e2c85b3f06606af99cb3e0edbb0af9c5d47b4171b2f598f7492c1312f1c397e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e2c85b3f06606af99cb3e0edbb0af9c5d47b4171b2f598f7492c1312f1c397e"
    sha256 cellar: :any_skip_relocation, sonoma:        "791b494a4bf2c97e17a2bf7d10700bb5f00f5b0d562c02dde0ada7f97149852a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a6cf2dfee1d84d32deb187bc57cc40d1395dad553c0b60f1833e17c39fa4e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4c00b5859a877e11cda0c9089473751f95600485ab26d6b1dc2bfdc3c23930f"
  end

  depends_on "go" => :build
  depends_on "beads"

  # update timeout for `bd version` check, upstream pr ref, https://github.com/steveyegge/gastown/pull/871
  patch do
    url "https://github.com/steveyegge/gastown/commit/991bb63dc0181d5d6356d52a6319d70ff1684786.patch?full_index=1"
    sha256 "2d584793851a1ae00e71a1fbe77512c84a33b3d0b81e5203e92cc6c11d0f3bdf"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/steveyegge/gastown/internal/cmd.Version=#{version}
      -X github.com/steveyegge/gastown/internal/cmd.Build=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Commit=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end
