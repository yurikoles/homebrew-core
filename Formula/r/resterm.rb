class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "ffb4ca501bb8996512839686394fcc6eb8e310f19f8b67184ed2a81119cc8750"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "167b90678494084c5936fe7eb3535bb3dc28508b11608bcb1d3158cc98857579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167b90678494084c5936fe7eb3535bb3dc28508b11608bcb1d3158cc98857579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "167b90678494084c5936fe7eb3535bb3dc28508b11608bcb1d3158cc98857579"
    sha256 cellar: :any_skip_relocation, sonoma:        "835bad13a501da056578f8c93a93b8d44eb4ed6f4a16ec3145143b82398886f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc50a2be0fab78583c42f7fec0fe1a12acc8ded696050a0ce7d3aca4f0945c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "249337ffecba02bed247e4a3b50d60544d557a27b0f93c5af16eeb287441c864"
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
