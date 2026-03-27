class Jsongrep < Formula
  desc "Path query language over JSON documents"
  homepage "https://github.com/micahkepe/jsongrep"
  url "https://github.com/micahkepe/jsongrep/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2db5efbe33cdaba5b93d8a884baa12049b17174d839dce25480551a5fb358375"
  license "MIT"
  head "https://github.com/micahkepe/jsongrep.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jg --version")

    assert_equal "2\n", pipe_output("#{bin}/jg -F bar", '{"foo":1, "bar":2}')
  end
end
