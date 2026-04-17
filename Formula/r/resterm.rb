class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "666320fe78d21b372d3d1593dec3e2863aea1d112c8ec0c65e3592ec395b5022"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a25a9c7c69fbeb99b185f96d82853850b3bf70ac3c29a0f5197904235c19cfcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25a9c7c69fbeb99b185f96d82853850b3bf70ac3c29a0f5197904235c19cfcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a25a9c7c69fbeb99b185f96d82853850b3bf70ac3c29a0f5197904235c19cfcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a2819b55ea38a36177389e740d9b93e63671e77781534b78e587079b0096e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fddd696d17d2180a4ec0073f88e662c29ff23a88a398779cdfc7c94f2225853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114a950de0f4af1e908b42360425c74761585e7e40a16b1d27e80c041769d9a9"
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
