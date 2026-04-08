class Sheets < Formula
  desc "Terminal based spreadsheet tool"
  homepage "https://github.com/maaslalani/sheets"
  url "https://github.com/maaslalani/sheets/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e33563769858abba1812d6f9e1f427241a9a5c65da3a34a87d8784c8a050e25e"
  license "MIT"
  head "https://github.com/maaslalani/sheets.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75ac510571c868f70119177cf4bcef943606c5f3d237ef2047f506a49af9a910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ac510571c868f70119177cf4bcef943606c5f3d237ef2047f506a49af9a910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ac510571c868f70119177cf4bcef943606c5f3d237ef2047f506a49af9a910"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f91eb68787c27e42198dfb1f555dcefef29fd5365992139af490aff676dbe19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32df9b00652e83279c9c75e594aad51f4dd9e772a21c21401acc114433bd83b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4e4bdfd490e1ae698abf3a4d89be2722f0b0679fa43ddbf47a9484f6a0c2596"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.csv").write <<~CSV
      Name,Age,City
      Alice,30,NYC
      Bob,25,LA
    CSV

    assert_equal "30", shell_output("#{bin}/sheets #{testpath}/test.csv B2").strip
    assert_equal "Alice\nBob", shell_output("#{bin}/sheets #{testpath}/test.csv A2:A3").strip
  end
end
