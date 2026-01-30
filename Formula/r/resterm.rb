class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "b3936e4cb0592f16a73d5592c4bdfe49ef7477a18026a6205702388bcc12411a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0db6009b5c6a86c1cdb10619f1c786843e07cbab9268f4b3ef16c4df0ae4db61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db6009b5c6a86c1cdb10619f1c786843e07cbab9268f4b3ef16c4df0ae4db61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0db6009b5c6a86c1cdb10619f1c786843e07cbab9268f4b3ef16c4df0ae4db61"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7c8ab1ab7c03db668de5e00020419648f6b5533fdb9f9ba7bb088c919c9e457"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3904a9d3f1286053cf1de325a5fa89c034efd53c087c0190e300ac5a6dc59e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bdb160f2802e81b03239d870323e51d491acf367c65edd53396fdba542e8710"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
