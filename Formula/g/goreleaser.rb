class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.15.0",
      revision: "97c05b9cadd9fd996272aeec084181f4c43c0b62"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53283fa67de9e8d4da152ef343a881ab15b12852c1ec32465256b60f2d7ce9c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a1eac68d8ed15c617af6f8857e9eedad640f0d2dfb036d5bf96893ee2f1de03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef16cafe706a131b6fca1fc101fa4b86854e88bcd1669ad81025acd6fe575741"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee4f7271280839566cdcb9b048b290e90f9b373038198d8c35e5ace3de6b55be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34540bccb58689c7971c52449f22b66e0e795a978cfbb156d58cfd5e5760fedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eada28da4c3ec9e60b49a4328cfd6fae9f48873b02acf6ff441e6f80fea45e1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
