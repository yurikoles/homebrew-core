class Crip < Formula
  desc "Tool to extract server certificates"
  homepage "https://github.com/Hakky54/certificate-ripper"
  url "https://github.com/Hakky54/certificate-ripper/archive/refs/tags/2.7.1.tar.gz"
  sha256 "d73bc25c3ab37467764310e8573895953b4ff80cf045d96c90aa3c24a67a4f05"
  license "Apache-2.0"

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "clean", "package", "-Pfat-jar", "-DskipTests=true"
    libexec.install "target/crip.jar"
    bin.write_jar_script libexec/"crip.jar", "crip"
  end

  test do
    output = shell_output("#{bin}/crip print -u=https://github.com")
    assert_includes output, "Certificate ripper statistics"
    assert_includes output, "Certificate count"
    assert_includes output, "Certificates for url = https://github.com"

    output = shell_output("#{bin}/crip export p12 -u=https://github.com")
    assert_includes output, "Certificate ripper statistics"
    assert_includes output, "Certificate count"
    assert_includes output, "It has been exported to"
  end
end
