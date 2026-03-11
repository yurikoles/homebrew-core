class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.6.1",
      revision: "906fe48afe651f5cc79e1f3f8c0a9110d45a845e"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39886be4befd353b4464b5368d64515e6515844e0f5399ed7f496826db5cede7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38aabb78bb527e87bd194bbc8cc4c576b3854408de685611c601ed8080fa2863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d77d65189af732c437815a361058003fd0dabe5e4a4951ce75a5858e158e7b9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c61dfe1f0f52d0fd016a304920384674a8044f679c9e110691149c19482ff0b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "048f8be69ce06b19bda61a44ff33492258f56b6dc06e53d8b351f2e75617c8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5051c12c86190010ed57cecef0614e7b45a24e939a859f2fc7e129dabf6df31"
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"

    generate_completions_from_executable(bin/"s2i", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"s2i", "create", "testimage", testpath
    assert_path_exists testpath/"Dockerfile", "s2i did not create the files."
  end
end
