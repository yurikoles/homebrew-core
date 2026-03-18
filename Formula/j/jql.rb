class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/refs/tags/jql-v8.1.1.tar.gz"
  sha256 "8032f8478202159299a4a038f20473b3a675cbf316038478e528be80cad0f9b5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yamafaktory/jql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaf7c4a0e24e436fd092401818977292f7f2a5260cdb6f75cc9673086abb07af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c264b46ccd130cf496d6e96b949190bd8c9286d0ee70ad4f8424c572c5eb5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34d1bb4020143494d458c69023880e2e6f5ecc0ff28661caa93228d6a9961dab"
    sha256 cellar: :any_skip_relocation, sonoma:        "db5c8bb7b7c632beb3e7b924937f4dd1f41aa5ecf5891f2e7e24a16be40d922e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "277335e9019285fab4cd5abf026693b06774fe1fc498741f4fcd850c82823575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0306f51f8e82ff18eb50980ed5cb5ccb54a8e0c9f475fa3ca1e89b8955a235a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jql")
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    JSON
    output = shell_output("#{bin}/jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end
