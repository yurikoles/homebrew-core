class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://github.com/oug-t/difi/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e61c441cf89e70b4bca095c025b7940bad590d5af9d2817975240611b653a1d0"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa6203244bfc28f7faa61424dbc19fee6462d7df0b815cf4560a28d358c38ec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa6203244bfc28f7faa61424dbc19fee6462d7df0b815cf4560a28d358c38ec6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa6203244bfc28f7faa61424dbc19fee6462d7df0b815cf4560a28d358c38ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "00ac99ba5908b107e8e2a1098b8f860a98e3665b829af235ccae4d45a2b8cf2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb5f03f66d6f3bc3734c250938e4f693b1730dc4a3a97b89750f5b819a533ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b57a59b8344c7c34a615dd19b78f0fa795ed5372610fb59586d19c47d028a23c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end
