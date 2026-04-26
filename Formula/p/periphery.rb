class Periphery < Formula
  desc "Identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/refs/tags/3.7.4.tar.gz"
  sha256 "6e3eb93904d4ea3ba346526b3e7dd90d0d258d4eff91977b859b91115f028711"
  license "MIT"
  head "https://github.com/peripheryapp/periphery.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fdc178f4b0f9adad570ec7317df4f6515cff29d435254acebfd25fe6bca416b3"
    sha256 cellar: :any,                 arm64_sequoia: "6e8d4b959b61c1d93178e2aa83eb843867da68332fb4e735672a90efd585e01f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea6afe7271e3bcdd4bd24aa730343d02326f4fa807a1990eac31a2736259cf7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cce114f7b84975c098ee150c8c6875c0461d55d23845d277648f5ec5d308cb59"
  end

  depends_on xcode: ["16.4", :build]

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "swift"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      swift_cellar_libexec_lib = Formula["swift"].libexec/"lib"

      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld", "-Xlinker", "-L#{swift_cellar_libexec_lib}", "-Xlinker",
       "-rpath", "-Xlinker", swift_cellar_libexec_lib.to_s]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "periphery"
    bin.install ".build/release/periphery"

    generate_completions_from_executable(bin/"periphery", "--generate-completion-script")
  end

  test do
    system "swift", "package", "init", "--name", "test", "--type", "executable"
    system "swift", "build", "--disable-sandbox"
    manifest = shell_output "swift package --disable-sandbox describe --type json"
    File.write "manifest.json", manifest
    system bin/"periphery", "scan", "--strict", "--skip-build", "--json-package-manifest-path", "manifest.json"
  end
end
