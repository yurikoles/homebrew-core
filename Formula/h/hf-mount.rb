class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "b75bd0ab4e209a73e510f75b3cd98894c636b85fec848f56322cf927480a113f"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9098aa30f3a6c4d5d2a556d27f2fa044d3eed5cc478f79bfd7b2e07cc10f6fbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dd8c1077308242db1a4e9c2705be33396a8421a2b8326ff2fb33d22627e68f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67535e537378b8eb84a8b436d0baf09de6d2b4c9c362cda20e98844df0ae661d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6c5ef2363e2e90ffcbbcc9a681566bfb16c0091d531e3be849445f0be71bedf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f753a1ebe5b6c1c54abd417fd2266da8acb94e524cff73a645559b501a52dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb617ef905e8275ed4e1ae3386f305d1a845abf2c39f87a473309dcdc3319f5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "openssl@4"
  end

  def install
    # macOS FUSE needs closed-source macFUSE (not allowed in homebrew/core)
    features = ["nfs"]
    bins = ["hf-mount", "hf-mount-nfs"]
    if OS.linux?
      features << "fuse"
      bins << "hf-mount-fuse"
    end

    bins.each do |bin_name|
      system "cargo", "install", "--no-default-features",
             "--bin", bin_name, *std_cargo_args(features:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hf-mount --version")

    # Daemon registry commands work offline and exercise the PID-file machinery.
    assert_match "No running daemons", shell_output("#{bin}/hf-mount status 2>&1")
    assert_match "no daemon found",
                 shell_output("#{bin}/hf-mount stop #{testpath}/nothing 2>&1", 1)
  end
end
