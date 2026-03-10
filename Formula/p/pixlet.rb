class Pixlet < Formula
  desc "App runtime and UX toolkit for pixel-based apps"
  homepage "https://github.com/tronbyt/pixlet"
  url "https://github.com/tronbyt/pixlet/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "cae46926f4069f7e2e4e550c8337b27708bb7e3e0eec352db85dd6ec2fbe0a7c"
  license "Apache-2.0"
  head "https://github.com/tronbyt/pixlet.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d7060a7922dfa693b61fcc949c383e379abd56d6b3c5804220aa84a46154058"
    sha256 cellar: :any,                 arm64_sequoia: "4c8c7f11abceef56f36c1169f8d7c688e2799465732652ddd21bbf06fdaae026"
    sha256 cellar: :any,                 arm64_sonoma:  "e8dd998ce261c8271f5923270f2cd9a9290b29499c2574f14cdbe89d4290498e"
    sha256 cellar: :any,                 sonoma:        "852c341334751a94ffc411b5c51ac428b6cfa1c29f6a62baff69a5feb7e4e0a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8792c18c2b73b090afdba0c5b2eeede8e72d786d5f41abca9fda09a9a26d801e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7c5d8fed769be09795f43b01cb1ee4d2f4545949b6cdc7236c074e4b4fd4e01"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "webp"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    cd "frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = "-s -w -X github.com/tronbyt/pixlet/runtime.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "gzip_fonts")

    generate_completions_from_executable(bin/"pixlet", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"hello.star").write <<~EOS
      load("render.star", "render")
      def main():
        return render.Root(child=render.Text("hello"))
    EOS
    system bin/"pixlet", "render", "hello.star", "-o", "out.webp"
    assert_path_exists testpath/"out.webp"
  end
end
