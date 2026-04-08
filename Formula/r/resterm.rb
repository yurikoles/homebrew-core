class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "21fcb08115483de2ff1195ae5ac57aa62abb396529c42307dd8964e42bab4d2e"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "418c5ff035b33c7d6df56981befbe68f9c68c49f83c700e85d1fcbdca8b32593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "418c5ff035b33c7d6df56981befbe68f9c68c49f83c700e85d1fcbdca8b32593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418c5ff035b33c7d6df56981befbe68f9c68c49f83c700e85d1fcbdca8b32593"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8a660abb5ed9e1695276c803e1a8138c8b99ae079d6593799783204336fb6fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66a53356f9af348663b519b85aa819899aefed450a34d1f8134856357370d1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b29a85893f43cbe1054cea01c07e5fa3f9a5465cd2c99d458b7423df5653347"
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
