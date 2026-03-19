class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.17.8.tar.gz"
  sha256 "76aca0215c043d1174b3baeae94d0af5e837c4fcdaa6d359e4c59bbbd448d9f5"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6252c76fe84df09094e60842b4a8e4f398ea7605c29ac13a49a9f8a4ea109241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6252c76fe84df09094e60842b4a8e4f398ea7605c29ac13a49a9f8a4ea109241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6252c76fe84df09094e60842b4a8e4f398ea7605c29ac13a49a9f8a4ea109241"
    sha256 cellar: :any_skip_relocation, sonoma:        "c375bbdea7d7cc710be93faff88c56861dad4d27e71175f30259108079f39644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1c36b2f0c86c82fbe92bd5df2f349ad93c78994e2107518d5dd43d36acf216e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36dd2bf6118b6689f3c8c89672a6cd6a4b20abbd96d704b9da43c8973f4fe1b"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
