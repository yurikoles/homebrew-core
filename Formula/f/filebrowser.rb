class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.62.0.tar.gz"
  sha256 "c7b005343a028b10612b448f94e788a1d6c609d824ea821a3dfb0ea0df4d68a9"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb0cd51312063ae7023ba293ccd5ae201e9cbfd632da6e47275c4f8beed0dcc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e49d1935f67aa8216bbb663a3a0ee62fd6529c71483236a4269e6e9b46aba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b9934bf0c306f61e3f26e72c525d03bc6dfa7fce39fe594d23d6803872faa12"
    sha256 cellar: :any_skip_relocation, sonoma:        "25a786883427465a0e3401ba0d25d97d718d5ec85736d3d10c8c1484ea61d327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8ec802325258f0146673002922e96833803db00d672827e12605182b2d5de5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d19243a1c3befb6b8e8c18601d6f4f8b0e9ae4a108af0eab03c2a7371766a8f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end
