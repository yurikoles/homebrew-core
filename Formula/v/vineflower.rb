class Vineflower < Formula
  desc "Java decompiler"
  homepage "https://vineflower.org/"
  url "https://github.com/Vineflower/vineflower/archive/refs/tags/1.12.0.tar.gz"
  sha256 "25c783b5b73fd0ae8c904c9ea3e7ee1e6713812d4d5fd085547fb20f1dacfdfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e77a21a55ef74e9c8310e0121698f1eb50830d344ff5acb3ced54e2ed54c9fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9293fab5c6221a1e271be0115ee8af9e4f49733b26094e55a4d70de43e75c493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18f0c90501bba6530cfbd62200450d74f91bb77b3f6453e1343e8cb1cf868566"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb76ee96aa9cbea200a151bf7a24218dbc0b6994ef75efd4e48459499e86ee72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e17ecf2cf39fcb0618d53e2602726052e4a123300f883f97f8a28777113615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf0610c249ba909944aec7b19f2b2ab4110a34d745fd9184fdbafd8eaba0138"
  end

  # Issue ref: https://github.com/Vineflower/vineflower/issues/495
  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build", "-x", "test"

    version_suffix = ENV["GITHUB_ACTIONS"] ? "" : "+local"
    jar = Dir["build/libs/vineflower-#{version}#{version_suffix}.jar"].first
    libexec.install jar => "vineflower.jar"

    bin.write_jar_script libexec/"vineflower.jar", "vineflower"
  end

  test do
    (testpath/"FooBar.java").write <<~JAVA
      public class FooBar {
        public static void bar() {}
        public static void foo() {
          bar();
        }
      }
    JAVA

    system Formula["openjdk"].bin/"javac", "FooBar.java"
    refute_includes shell_output("#{bin}/vineflower FooBar.class"), "error"
  end
end
