class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "690ba9f7e70544ee101cda38d57fd79d1e614f4241a39b253ffdf1ea125cdc1e"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00873c54bd673a99bc65064e55e09a09200eb05fa24ea3a2a63ba7f21dc59772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00873c54bd673a99bc65064e55e09a09200eb05fa24ea3a2a63ba7f21dc59772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00873c54bd673a99bc65064e55e09a09200eb05fa24ea3a2a63ba7f21dc59772"
    sha256 cellar: :any_skip_relocation, sonoma:        "6545be60ea220a2db527480ce747a89f9645c2d079bfaac2c0a054ce9d31dce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16cd1dba3ede6dc0d2474ea2245b0fd8cddb15982c51895bb9af92895a64a818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d0c4e0f15b84d5d8cd64fa4f5c83930dfefd881b3d9c695b88f1ee3e526d69c"
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
