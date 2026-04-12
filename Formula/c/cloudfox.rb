class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "d2257c94f4134556a8219e6a8f92d39b5320a970ebde0272f0df43c92449ce73"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1535f63bf52392205ac68dce9a6898f7bec0d5b7b2470696f219253083c404a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1535f63bf52392205ac68dce9a6898f7bec0d5b7b2470696f219253083c404a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1535f63bf52392205ac68dce9a6898f7bec0d5b7b2470696f219253083c404a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0242cc7ef0b849d50221f900cc72f4c493aea89f367e1672fac2434fa4801f5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee765a524cbffefcb80e2986aa6bdcd0f6f934ef8746070aeb14afdb134c6c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "670fe16c63f8c51c790ab75fb07cea0887713ed6e359bc2b9fd77c804e836ceb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", shell_parameter_format: :cobra)
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
