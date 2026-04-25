class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e8e5b31390efe20868ae324c0a3e09f609cd62c5bfe08dc38b79deb554d6d119"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ca034db6ccaf764da65f1d6df5318e4192b1c5014dd158a1aeaa2f38dd07220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ca034db6ccaf764da65f1d6df5318e4192b1c5014dd158a1aeaa2f38dd07220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ca034db6ccaf764da65f1d6df5318e4192b1c5014dd158a1aeaa2f38dd07220"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb57da4744bb4b5a95ffac47cfdc95c60449e7ad6a69a585790269c9ad25011e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a55182592a822fa5862235cdabda3d8c6fc0f86df1d7ae46f654d209830d5f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f10db030fe964aaa6fe1aaf27d009dc71e8a44e855459f34a4ff746629cb0cfb"
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
