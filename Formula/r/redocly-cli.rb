class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.6.tgz"
  sha256 "5faa3e741641a470b6f53e3cf571c4eddd28db7234427f7837db445dae684665"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29b0e0399a716048ff34f96937ab9cb2422adcb10729e20f03a44406e8ec9e4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d69ef2f87d15e18eaff8f17998d799877035bd7c2d9238d0db481c436e98acb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d69ef2f87d15e18eaff8f17998d799877035bd7c2d9238d0db481c436e98acb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a92a7533064120974a1253f435a0a33e1979ce0784abd3960615d561d7541e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f2b0dc7578553af6207fbb2382837dba5e351b1d7426abcb235c80d047cbc9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2b0dc7578553af6207fbb2382837dba5e351b1d7426abcb235c80d047cbc9d"
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
