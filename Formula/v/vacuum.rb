class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "022cb37edef1409bd4f248a04f264c4c18164d36c109643966749cdb9f527e59"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca29175c8fa7d4874e71afb8b40c8c82c613877031f372870a2de76f5a0d75e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c04550855e1d2252b93aac5c1cf4ac26e348fa5c6ab5f22dc4e0719e1b1ccad2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72e0fbf3cefb0f336f90250eeaf45e8c85b07b240a693f631ded2d195294e42"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fb5a28afcbafb19d3c7a85a4a3dfb9b16742709e6ebfe17adb9ab98c6917c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3eb3a55e8ddc8cdbb275ab52e417ea826ab1bb48189a43943dfc732877996ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40ac728c5a9f325c0fc33628f8fd3f6b0ec9a4523978eb0bcd9c55b804594ceb"
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
