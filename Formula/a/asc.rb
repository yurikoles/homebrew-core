class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.41.1.tar.gz"
  sha256 "e3f1064fc08801a910b6eaab9d037559f8feb0f8c985c2675e7cf6aee7ccb039"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8132aeb681dbae020c2e84005144b9d1030eeffbe5f4cc297ad10ffcad0b1ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ce32ec77cbee38db914cf3abe44aed3cb777714809fa99f5ed3f3749dde5f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9d5c85ae05964663bbf5e40927bc216362c2eb18a0db5b0cb118083dd43f8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c55ff40ce3186d98271f0a43b254ce20665dd4ba953c7006b26a723fb2c8e5dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec4d106b00912a61f579c3b69aa327f86003420908ca7ccb433027eefa421d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5348951efaaefb3aebd9514ffdd158979246d5a5c45fefd7e0a50b153cc58942"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
