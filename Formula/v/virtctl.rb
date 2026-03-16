class Virtctl < Formula
  desc "Allows for using more advanced kubevirt features"
  homepage "https://kubevirt.io/"
  url "https://github.com/kubevirt/kubevirt/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "2a613fe591ddd1a0f70fa459065c17180ec7f67cf0906ec13f352b51b3cd2c2d"
  license "Apache-2.0"
  head "https://github.com/kubevirt/kubevirt.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c51c1c0c7e22437cd8f02b20ed05093e474d961236e15207ced70a90716e047a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477e7e5c312299228cdfb343739183a9e93fe0dbdd67d234484f0e877642329a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "446d7777330b35915cdaf294977533af7b0a640577bc75b904f48a10c2cf727f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e847e2a70512e3fa74971c0f3fc6f9b4423ab2776d085dc39abeca4d6d5c038a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7363e760552e5a648d4dd7a7557101c3bc042d1c6da41fc2de3c23ac63bcaeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a5587b45e49a3ae6d852e404076772e470376bcf882c7f8c2ec475d46ed2b4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X kubevirt.io/client-go/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/virtctl"

    generate_completions_from_executable(bin/"virtctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/virtctl version -c")
    assert_match "connection refused", shell_output("#{bin}/virtctl userlist myvm 2>&1", 1)
  end
end
