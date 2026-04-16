class Jdtls < Formula
  include Language::Python::Shebang

  desc "Java language specific implementation of the Language Server Protocol"
  homepage "https://github.com/eclipse-jdtls/eclipse.jdt.ls"
  url "https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.58.0/jdt-language-server-1.58.0-202604151538.tar.gz"
  version "1.58.0"
  sha256 "2a5bbe55ec91b4325392050dc422cead3220a2459b3766be35e1fff45b4a50d9"
  license "EPL-2.0"
  version_scheme 1

  livecheck do
    url "https://download.eclipse.org/jdtls/milestones/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5516b1b93b0abce41dc3ccfe23d61dfe6cf0c6f1d5f16756a5d83f3832b9d00e"
  end

  depends_on "openjdk"
  depends_on "python@3.14"

  def install
    libexec.install buildpath.glob("*") - buildpath.glob("config*win*")
    rewrite_shebang detected_python_shebang, libexec/"bin/jdtls"
    (bin/"jdtls").write_env_script libexec/"bin/jdtls", Language::Java.overridable_java_home_env
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"jdtls", "-configuration", testpath/"config", "-data", testpath/"data") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
