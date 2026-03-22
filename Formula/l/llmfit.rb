class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.8.2.crate"
  sha256 "df24dfc991d5500a8b85841e747b7e416d3e016eeb615c4a7abdb7e4da22f369"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "272b40922324e835f22310d0f7601fbd8f2e3c896a184c8a479ff2f6b4a44f3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb332fc9eb5b9eddf9e5b816faef3200cb875e4e6567b908c22c150c4819377b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ecb5dc2300e064c2cbe74ba40f378b0045b8d4dabe9c92f60b46cb06b75d8f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ecdc1bdf73eedd357a19159c5005067a1b2d9e42db26b237adb4241af492120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7209e17d38492c5e38da0d150d193e68b5123b4a0d97f54013d51f79e9199359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e38772d0e8af02e5e38ac99ea54d0fa17538565f90bf1748ade5e104f627da0f"
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
