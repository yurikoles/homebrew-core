class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.9.0/nifi-2.9.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.9.0/nifi-2.9.0-bin.zip"
  sha256 "3376074740d632160aa3916104fd8ee7fbb7630eeda5b4ef319bc1a52d9a6e06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f378f643fdce80e5748668aea070f67e1b813282727b24f598a37969947b046"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("21").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
