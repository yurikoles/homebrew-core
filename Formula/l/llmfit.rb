class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.8.3.crate"
  sha256 "4f812b9a33ec73bf91d1559de80733e2f38268140e966d8d4093a3cff8ce93c1"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ca2c5f12f6dd3771f0485d9125bc8b3a44062b3891969e3cde841eae7d42ee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b1c81c2926a12d00c4f6c56dd798243c7358510a12417c6d788c5f273b0d657"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c6414e66f1d2411c12e67def7860a9fbd9a4895a7da95b58635cc99008bd09"
    sha256 cellar: :any_skip_relocation, sonoma:        "d856649ce609bef4132e9fbadb5b980bf8577be2344a4218f716378d9191fe69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a9fd2b20abc9ea166b2998c8fca9b50e723319eecc849af38a38cfb4d8782aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19af86fd03436f9dddda8d1527a1f98e9998e672d15e15530a13cce7debd7400"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
