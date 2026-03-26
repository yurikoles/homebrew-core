class Devcockpit < Formula
  desc "TUI system monitor for Apple Silicon"
  homepage "https://devcockpit.app/"
  url "https://github.com/caioricciuti/dev-cockpit/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "c839630c5ef7aa29c9ee90af63fb504a540dcd7f1f32142921b31e37a0b46597"
  license "GPL-3.0-only"
  head "https://github.com/caioricciuti/dev-cockpit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dece4a0d00fa0bca0391c96feecce5c733dc0725e0221a7d97b38b5af471c2e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae82be2be0b6404342430f1a18a1c11aa553c52f12b1c96956787830261fda16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cb1762b5cb7b37210f18043eb7cd16359a820b67ce659e32018748a927514c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baa5ee9b9ce2c05dfdf0536b2e1857e8fda52ed64e02d60169c1f10ec68997ac"
  end

  depends_on "go" => :build
  on_macos do
    depends_on arch: :arm64
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    # Workaround to avoid patchelf corruption when cgo is required (for go-zetasql)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    cd "app" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/devcockpit"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcockpit --version")
    assert_match "Log file location:", shell_output("#{bin}/devcockpit --logs")
  end
end
