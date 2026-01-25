class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.59.0.tar.gz"
  sha256 "3547c8128d925dc92be59eb9c386a39533148b1ac91daaf1e6bbd5617eb0f75e"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcc8cc0c5f6bda7935993aa05083d6ebe573ac6197da51152f0197c2b853b946"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9e861bd8f6b0c217877b8348122cdcf9a4f0f5e40ffd54e4dfc6e15baa0e08b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "497cb6a71f6cb16893fadc3f8b27435bb8ee8aa44e3e26045d8cf28ccfe2e9db"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a99de82c2b83c2fd69f77904cb740439dc3c16bd8117e3199acf04c412fdf87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c1bf3918f2a61e81e2475d9aeb5014ca62960a6e1aa25a3ec4fee1063c0738b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05dda1a4f47c0d709a7b45bebbb1c3398c2e9f7a72174eb63900cb814d582600"
  end

  uses_from_macos "swift" => :build

  # Fix for macOS 13+ only Range.contains(_:) API, upstream pr ref, https://github.com/nicklockwood/SwiftFormat/pull/2328
  patch do
    url "https://github.com/nicklockwood/SwiftFormat/commit/9774a88b325382209eedc8e955cbaddc402b13a1.patch?full_index=1"
    sha256 "2f77becf3c71759e01ab1821871e6f78c10c25b7d3091b36f70202de3244eb26"
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", "#{testpath}/potato.swift"
  end
end
