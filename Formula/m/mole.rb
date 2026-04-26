class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://github.com/tw93/Mole/archive/refs/tags/V1.36.1.tar.gz"
  sha256 "0716376f2391dead6402ef2d39b5d46c2d86d835ca2b131419358ece77ecf27d"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a29adbae1c1cb9156c9f0c85ea4b7d02c2764eafc2d96ad0e6dca50ec935f21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2312d3c5362e993895261a8b14719190bdb79ef17992f14841f03bfede712602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e580f23859ba0fc6dfa7f2cb0d9c468d215fd475e40f44d2c2eaf4ebb27bbd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "115edfacee0269564a511ba7d9930743ab34980de4f4103c2c853f8b621771d0"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    inreplace "mole", 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                      "SCRIPT_DIR='#{libexec}'"
    libexec.install "bin", "lib"
    bin.install "mole"
    bin.install_symlink bin/"mole" => "mo"
    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end
