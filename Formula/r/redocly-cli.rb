class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.9.tgz"
  sha256 "e170f5079346a080dd8931f0b8e99c2c2d2cd1f7575876e9b08f7b33957beaf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fae20b4782f08672823db9d7c8b782aa8199a4e1f0bbf2ec4322daefcef5682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55ba1f32b42e46e281bd4f9c424901a1f8b39252644ef703fb1635356386a876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55ba1f32b42e46e281bd4f9c424901a1f8b39252644ef703fb1635356386a876"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5bf0428c96d73959e6daa4794ee8e84c3213fa0f754fdfb6eae4df186300010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df3ee946fd8d1d342588336d59b64cff5a687cb91f0b08e0351cb8294e752564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df3ee946fd8d1d342588336d59b64cff5a687cb91f0b08e0351cb8294e752564"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@redocly/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redocly --version")

    test_file = testpath/"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https://opensource.org/licenses/MIT
      servers: #ServerList
        - url: http://petstore.swagger.io:{Port}/v1
          variables:
            Port:
              enum:
                - '8443'
                - '443'
              default: '8443'
      security: [] # SecurityRequirementList
      tags: # TagList
        - name: pets
          description: Test description
        - name: store
          description: Access to Petstore orders
      paths:
        /pets:
          get:
            summary: List all pets
            operationId: list_pets
            tags:
              - pets
            parameters:
              - name: Accept-Language
                in: header
                description: 'The language you prefer for messages. Supported values are en-AU, en-CA, en-GB, en-US'
                example: en-US
                required: false
                schema:
                  type: string
                  default: en-AU
            responses:
              '200':
                description: An paged array of pets
                headers:
                  x-next:
                    description: A link to the next page of responses
                    schema:
                      type: string
                content:
                  application/json:
                    encoding:
                      historyMetadata:
                        contentType: application/json; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}/redocly lint --extends=minimal #{test_file} 2>&1")
  end
end
