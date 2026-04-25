class HfMount < Formula
  desc "Mount Hugging Face Buckets and repos as local filesystems"
  homepage "https://github.com/huggingface/hf-mount"
  url "https://github.com/huggingface/hf-mount/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "6da1ee02422c493124aab7c5e5f2a823b2d66cad819d52d029baffeda74530f1"
  license "Apache-2.0"
  head "https://github.com/huggingface/hf-mount.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b690e2fd39005b4c9b6f862079511329ad4adf88571f018b6e51a1b47f14be3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f859f34058d9c9465552f544cf6bbcb012590ea429ed4b5e5847d4a74724c0f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "958c5d70e33833981ea86496a4618beac5fef22e2fd163cfbf818186af9be0db"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba731e2b694436a4f404e2acdf48e7d85e3477f64602804ce6b589af7d79490c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "846a0059adc6f63d9befb2756b6b6a5f2ce510e8d390a9bec3b8c740750c3ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0019f38b5ad0b6028c7e49463156aabe0ed18554cb1bf8f7416d8cf2a078a9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libfuse"
    depends_on "openssl@3"
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
