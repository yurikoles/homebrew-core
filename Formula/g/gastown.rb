class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3be366a86e205650d02e5e8096378505374b6ae14b699c0aeb6649ef0260d661"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3784b3598bfcbeee5ae44110ac86cf6c0dea678a89dbae7b05fad797dfced360"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3784b3598bfcbeee5ae44110ac86cf6c0dea678a89dbae7b05fad797dfced360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3784b3598bfcbeee5ae44110ac86cf6c0dea678a89dbae7b05fad797dfced360"
    sha256 cellar: :any_skip_relocation, sonoma:        "35ac62230bee9e0767236f73a4ea31a5cd6dd5b11c36a7f47617617651484e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf1521a2ceb9e6eaa3648f86408b4fcac3f90370c095f9ed9d0b720d36878101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5631e014075213cc2c5fbd416896461f1f953d3a462b3cdf78117e51897a816"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "icu4c@78"

  conflicts_with "genometools", "libslax", because: "both install `gt` binaries"

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

    generate_completions_from_executable(bin/"gt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system "dolt", "config", "--global", "--add", "user.name", "BrewTestBot"
    system "dolt", "config", "--global", "--add", "user.email", "BrewTestBot@test.com"

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end
