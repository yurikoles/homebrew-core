class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-18.0.1.tgz"
  sha256 "89367bad9dd6bd23359f96ba4368c226dc50e843cb0c8d9f2a8a379b54f6a07a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ff267ad1ec21fb91c8eee9af27c12687b622529f0a9239bd83036b0afc444e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e8b49cd1715f20e5c518ba999fd4a94f9b2a145a0a1e9e0d317ca95ebf8eedd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e8b49cd1715f20e5c518ba999fd4a94f9b2a145a0a1e9e0d317ca95ebf8eedd"
    sha256 cellar: :any_skip_relocation, sonoma:        "26a7db8571bd4608a8bd1729f40a8240917f0fa32d1b19fd2d8253f91b953c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9773bb5a0b36604216112e286a21366d0895f1499b39e9106946600d20541f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9773bb5a0b36604216112e286a21366d0895f1499b39e9106946600d20541f78"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
