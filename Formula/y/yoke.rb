class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.11",
      revision: "1182942b8cad5c9f1c469b3d08199b45bc56b48c"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e41fae6ddc003fe26dd6fdc636ac33c6eaa885e9ffa78392939d5f7767cdc25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "290599579ee69b641420ca20a8b9281a0aab181775e33739acde7dd3bb22c7f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e225d4340219aa20b862e015c7f9d1c7d1066a1166fc8f86126ef7f480323e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a6985d83f922960dadc35edc925c09d1eed0754a83ea9e626ac76b32c081813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8a7b90032f7c198aa684bf2196d46d4169658d9a3f0e7be93d6ae0d282e40da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54e6714e11692934a08874d465fa142cf6553748d5ae44f336fe595b39b2dbef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
