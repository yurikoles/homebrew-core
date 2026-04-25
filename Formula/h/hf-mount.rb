class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "cbe85e88a0bc60a2c23a1007f382bcea2f54195a9b9318a82241dfa5d921dc43"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b89c9b596ed47696b9fde483c8e1810a3d20506fdc14f8af5d982a05b596c69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ccd4f56a5103ca38566900b69c1015b75603cef027f5ff9503061ae75607f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9508483363fa4d89be604bac19d9b68223db43c6befc6811de76a941f4552f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "84b57489ae65b7845b80725a6a86e483eca4800b4a358c801a6b4b2c56941a27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aefea1baef5b2c14c1dbb5f8677a3c0fc2ec37a2fbbe5ea18a586313d6cccd6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d06bd79969c758b97173462fc7d8f9fc946e04d417d215034ea814f6cf906390"
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
