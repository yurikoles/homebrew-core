class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "e52b910a1534680f8e4854644bcb6d9827b409962a12c3760734f738ed20822b"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1f164e3fb310cf01abb5cd7fcb7bb5a8400f58b9fba2da45046e9bcec22c795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0ab3613136a6b4ae8d3221e0784fc6b9ec6b85886824a3dab9bae4d01b7f9d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "901c5c704b4fb6346efd3c8755e861b52c37f2e1d4c3f7ab37acc5df812d631b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e448d703e7ef25ab39e54dff98b2d66d38bbd1aab3737634f5904f87144385a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f4967dbe6631ffdd2445c18379297554b3ec357f1bcc574e14255f56ab56fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "504e78b788835e1fd2260569d82ded3b6a9c0046f31da5c7f77e62274a7e6104"
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
