class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://github.com/oug-t/difi/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "042ec3261e39d117c36dff2b94e0f473ba2d9e9b1e8df85846c25be502ee5964"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cef85d0e2e423476664517a8fd118f80923e9b6eda704f8d5c7cbefb1679058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cef85d0e2e423476664517a8fd118f80923e9b6eda704f8d5c7cbefb1679058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cef85d0e2e423476664517a8fd118f80923e9b6eda704f8d5c7cbefb1679058"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8bf44c5fd348c3e6f281731caaec00c93f48d457c1108af0033dff470dc2a4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd91bbdda01945d032a6af66c3bf9f168c6069f565c866a3265f34ddd18413e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c603adbe484d72e5cd4a7caa6f91b594fed450980f4a23b01104f467be2d34"
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
