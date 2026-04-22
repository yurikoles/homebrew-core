class Apfel < Formula
  desc "Apple Intelligence from the command-line, with OpenAi-compatible API server"
  homepage "https://apfel.franzai.com"
  url "https://github.com/Arthur-Ficial/apfel/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "426f5017da89d54d6f0251f8df602c86a95eb10247fa421a14a661bf2de20349"
  license "MIT"
  head "https://github.com/Arthur-Ficial/apfel.git", branch: "main"

  bottle do
    sha256 arm64_tahoe: "8086337395182b8ad9b6f3dd3b99b6e5b3a1bbd1a02696330ee6576084a17b6e"
  end

  depends_on xcode: ["26.4", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/apfel"
  end

  service do
    run [opt_bin/"apfel", "--serve"]
    keep_alive true
    working_dir var
    log_path var/"log/apfel.log"
    error_log_path var/"log/apfel.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apfel --version")
    shell_output("#{bin}/apfel --no-color --model-info")
  end
end
