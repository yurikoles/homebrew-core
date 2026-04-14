class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://www.red-gate.com/products/flyway/community/"
  url "https://github.com/flyway/flyway/releases/download/flyway-12.4.0/flyway-commandline-12.4.0.tar.gz"
  sha256 "1c3f4ecd90cf70c4c8a43c90e1cdc5a00c45823ca5d9f75759565feefba8c0c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d95ba4eddf880d8525cfcbf8653ca053ffdd70c9719aad1fd824738b03c069fc"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flyway --version")

    assert_match "Successfully validated 0 migrations",
      shell_output("#{bin}/flyway -url=jdbc:h2:mem:flywaydb validate")
  end
end
