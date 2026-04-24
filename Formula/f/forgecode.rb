class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.5.tar.gz"
  sha256 "e6efd2327a3bb0fc0467b6645bae7fb65af4a8794ae1f6e4bb3de782d890d875"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a14851486b54d2a807b863a3051d132766fc343fec99972c026821a8b60e8e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bae377763b2e9e580606c889411eddd63e593d0f68c37e2b888fc111de91d24c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b1cb89275748dc41b16569da50feb395ac52be1e5eb96eff410dee4a49ec6c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "54397fcfca7d0e257edf75a4885fd926842f680d7ffdc82d70670391ab755c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec28c02dcbd9b9a9eaa306ecac143c3840c742021425aa536fb27d97e48d500f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8ffc1b23916f486e8e8c351d2a284c42ff55e7d9cb7a21022dad24b590d43d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end
