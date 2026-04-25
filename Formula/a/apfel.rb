class Apfel < Formula
  desc "Apple Intelligence from the command-line, with OpenAi-compatible API server"
  homepage "https://apfel.franzai.com"
  url "https://github.com/Arthur-Ficial/apfel/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7743f5a9d70ae7fb1a6c0c71d06aa9f1317b83089d70572738c79d64af0ee201"
  license "MIT"
  head "https://github.com/Arthur-Ficial/apfel.git", branch: "main"

  bottle do
    sha256 arm64_tahoe: "87dfe4065a267078bfeb77faca0a1aafc00c0913029bf40a47d2aad92b3b3fc6"
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
