class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "1c69ff785d2869bad7ef8f0d70eaf4ae300063c3bc6bfa96471d490ef62c0ea3"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f6951d56003b5fc19ea97fee2fcacd1e7083a178684c013a569b2248a8d0314"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c62713da8759975e91d026698851eae425b7ae187822ef42426df0870ff7d49e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833f8648becc2c9a7385ea266b80426da44a346d0f706069a1929a4fbd88103b"
    sha256 cellar: :any_skip_relocation, sonoma:        "56de4966765f980b1e87bd90fdcd0bc42ac37a1283e47548acb55682130c09c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "167336ccea55bd15d3d128099ad784258c30233a4e865124d2ccfd7a3ade1de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59671fbfa82f7803df6414c6c37fb1cedf2bea73529d79d028c54d50cc25a6d8"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "html-report/ui" do
      system "yarn", "install", "--frozen-lockfile"
      system "yarn", "build"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output
  end
end
