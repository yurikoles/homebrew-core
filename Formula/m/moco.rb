class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/1.6.0/moco-runner-1.6.0-standalone.jar"
  sha256 "31a3dc5dd902afd4615903f10a8179e289300c497a8d01dd04775b7003350f75"
  license "MIT"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "521d8b998c0312dccbb48389843c42e5c3f3edb17618eaa8b017038d040a420c"
  end

  depends_on "openjdk"

  def install
    libexec.install "moco-runner-#{version}-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-#{version}-standalone.jar", "moco"
  end

  test do
    (testpath/"config.json").write <<~JSON
      [
        {
          "response" :
          {
              "text" : "Hello, Moco"
          }
        }
      ]
    JSON

    port = free_port
    pid = spawn bin/"moco", "http", "-p", port.to_s, "-c", testpath/"config.json"
    begin
      sleep 10
      assert_match "Hello, Moco", shell_output("curl -s http://127.0.0.1:#{port}")
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
