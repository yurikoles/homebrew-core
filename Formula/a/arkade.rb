class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.90.tar.gz"
  sha256 "6c3beffc4e0d5a3058a7934bef09c0e5809cf52030479e869c6d75a193ba6f45"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9c06f4473edbf29edeab00f5d5e92e93dfaca46c883770eb78bfb9ab7429c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c06f4473edbf29edeab00f5d5e92e93dfaca46c883770eb78bfb9ab7429c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c06f4473edbf29edeab00f5d5e92e93dfaca46c883770eb78bfb9ab7429c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa6ed1d48345e7ccc64451cf7c4a621529e85408ecb536578dda73b07348ca29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00ce7a1654fe4388b1a2e49b3205b9f1d5a63b43366ed94c3725962abb1b4a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f361e628d55964e5aef02f7ef107f00dce84574dc6b3e333b8246d2e67d61f40"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
