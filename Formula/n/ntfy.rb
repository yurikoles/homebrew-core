class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "b564e16166711a319a21cb5711e2d000ba0332454c2af8aaa168b2b5e77ea8de"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01ccfd97f9688748664ed8da6709ffd20ea470985bcb02051be210be161c952e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ccfd97f9688748664ed8da6709ffd20ea470985bcb02051be210be161c952e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ccfd97f9688748664ed8da6709ffd20ea470985bcb02051be210be161c952e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4626928e15827bae19fdafb2d03c1e39215b69371529342049d451dc107f3240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e66be504a41180e070f86c81dd8b4e6d1a91ba82f08613402a734fa1c54a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bddbf63caf2ccd127b0128473f607dfc0e7fa09d586beb1b58d061570efa7008"
  end

  depends_on "go" => :build

  def install
    tags = %w[noserver]
    if OS.linux?
      tags = %w[sqlite_omit_load_extension osusergo netgo]
      ENV["CGO_ENABLED"] = "1"
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie"
      end
    end

    system "make", "cli-deps-static-sites"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags:)
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end
