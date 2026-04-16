class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "416ce0a02f3368723634022fa592cc284c736675a36c2dd549963143df7304c5"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f280ff28606f32c287c79eda1d550874116f63b8b8455d42b6bf60e533a58c85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f280ff28606f32c287c79eda1d550874116f63b8b8455d42b6bf60e533a58c85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f280ff28606f32c287c79eda1d550874116f63b8b8455d42b6bf60e533a58c85"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fab9264aa54cbf732101f741e18249cabd12a2146452c125c2b27dd1916d554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b31df8bc104082018bf6e5df0665f5c461a8de369bc02dd6ae43ba25bbb3073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8eb674ddd24c8b0a2999bcb3ac15c926af07d6ff33a472aa98c38e0cc0b979"
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
