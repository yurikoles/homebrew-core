class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "51206f0f7df35470acb4e1463eed54963ed565ee4c1dc6bff2394647810f73db"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2df3d9674869de8cc63856a2357610916e5aaa10b2aa6079a436379aef4c51ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df3d9674869de8cc63856a2357610916e5aaa10b2aa6079a436379aef4c51ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df3d9674869de8cc63856a2357610916e5aaa10b2aa6079a436379aef4c51ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f551b0d9917a55ccaa38bb872a14c5825d0e5fcc4986c586fcd7b6124ca9a801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b0ca6f34dc7042bcf76ad9d50f32801bf21fa90dfcd74534ca5f34fd4445d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e66d5457592850fa2a9ad5850ca1b24d9f748221d4d008e3bae6c571fe9a5ff7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
