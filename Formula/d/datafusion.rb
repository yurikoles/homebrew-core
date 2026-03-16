class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-52.3.0/apache-datafusion-52.3.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-52.3.0/apache-datafusion-52.3.0.tar.gz"
  sha256 "6575236cb18bc91f9dc0da218439a11321873e28bcfae130b96356f2e1f71549"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc9759eadd9bf1949208a8c67701e562906b826ba683ec3163627d3c8cb99c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e0da6b21308dac31b9ae7b842dedc1af4b4675653ffb9c6048386ac2df00a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d1d365b8cff9cf73077c2f7873b2074071a5d1a42e8817da5d1012de483d66"
    sha256 cellar: :any_skip_relocation, sonoma:        "a35ba3cd8d1ecbbeeedf00929da7855cb6e7017c9238d080959aca7e223db8a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91864565bbc70f6b8168edeb95bd0c7a5a3dc32590022a4796891bbad1e93e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4101828c06a906a08c77f408b38dff4f5986cc58543592010c410ffee0ecd9f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
