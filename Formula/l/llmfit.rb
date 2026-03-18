class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "b214a57ea9ea4f4f110183f57b4cb21ecb8d817c4e0ef16d0d42bf0e1f0aad3e"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6aba32c9620b32f6d5a5940982ed0bfd44a2f9933315280d8e221e8cc542cb39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04b5a137e25cb6194b5364f87a6d71fee05b0d943623dbef744c2a577e9ad949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "736c597083cd2a38ae6f9b7fd30a06be1ffcee05bedf71d35e07c8bde8421348"
    sha256 cellar: :any_skip_relocation, sonoma:        "66dee14ff6a96d3548a554d77c2ffc2701115dc104de6153a0d79d5b4cbb3722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f4b6864776a4c180ce8a674f8f6ea0223e87d5f28f6c224251b44d7ac4eaf55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d64589be0cac6875438d72f04c7bbe03a9907f4384e3253b27717005258a29e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
