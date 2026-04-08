class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.94.4.tar.gz"
  sha256 "31872de7a06aa5591e5dd3193e9168cb04761ea65949fd825ef129ef4367a612"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8751461694755bbc47f060fa7ca1e8d509c147aef4ff56a2013ab50c391be8c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bae36dc866b0c20a3000be68f6ddaf14d5b2e45e6b38919126085bb190b8a197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39c294178de45a6dbf7a4c2e4c2c0b8e217805d398b6776d02e84acf2b5a0392"
    sha256 cellar: :any_skip_relocation, sonoma:        "19dd1f78639405d00bb04ba69666430e4d416e185ef74fc1d3ee89ff32d1bdf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b848b8c0906885221a76c817f2a5cafc23eb501313207063415fa3afd306ddd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1ddc71e0e1e8254ad9765598e3f1752d670055635fbe2579ddf847083ef91b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end
