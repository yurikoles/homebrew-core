class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "c457d9843a512932f6baf37690492d7395af7200cfe3bb9d86f3bd082332e96f"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1097acf697bde7b163dc8f8ed76301917e70d649c35e6774866cb426d8ac1d98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1097acf697bde7b163dc8f8ed76301917e70d649c35e6774866cb426d8ac1d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1097acf697bde7b163dc8f8ed76301917e70d649c35e6774866cb426d8ac1d98"
    sha256 cellar: :any_skip_relocation, sonoma:        "925330d8374f13281ce691435e3d3d08a899c1f004cdb4c14d3ca98ddb529dc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb3fe4eed058aeaa9578ddd020a3937eaa968b7e28e1d2daaeb3a31467caede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eb1a4b3913e477da11cd5cbc3a868e44b77c987e91685e5edcc261f1470baa4"
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
