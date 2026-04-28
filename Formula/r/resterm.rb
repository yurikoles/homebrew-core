class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.33.4.tar.gz"
  sha256 "098f6043777460a769e06d7df0c2f74e02abca1e63de6f5f7e92b9802aa7bc10"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5c22555caa951a282d7aabae2e23fdc7daea4b3455d04f3f9811317a8b75d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5c22555caa951a282d7aabae2e23fdc7daea4b3455d04f3f9811317a8b75d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5c22555caa951a282d7aabae2e23fdc7daea4b3455d04f3f9811317a8b75d2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7cfc1f138e50143cbde767d863d9b27f8e00d51fb9f45988916c6972f5ae479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1971efd78b43ad1334989b950b583b3e1baa54938bbdd68dfe06c8d74df0973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2af2b5b4778a1c1b935530da4780ee67a70230812e587c2c6abfcad47b1eb5e"
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
