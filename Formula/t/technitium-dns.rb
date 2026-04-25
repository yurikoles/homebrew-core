class TechnitiumDns < Formula
  desc "Self host a DNS server for privacy & security"
  homepage "https://technitium.com/dns/"
  url "https://github.com/TechnitiumSoftware/DnsServer/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "f2f7cc829699adacfe3fbf2dff735e02656c6f7ac1076fa4e07c90db62ca21eb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "985294f14499dc8b8bf5e88b5864fd63c2f6d0faf4c84694bc80fc6933139788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ed3b7b6ac909a94f18d4f85f31448a741523b4b09d2f9d62baec3c02e572df1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "082f392340bfc89f4e507b023db57a75b8cc72b6fe105b9e7a798a0eabd5a0dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4716ff2acfe129a9ec49b55f6b8bcc025276a8c0ba548b32361aa27f932991f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b95454ad1fa1891156fec79b9c0ef3fe515e218df1823319591837524a69799"
  end

  depends_on "dotnet"
  depends_on "libmsquic"
  depends_on "technitium-library"

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    inreplace Dir.glob("**/*.csproj"),
              "..\\..\\TechnitiumLibrary\\bin",
              Formula["technitium-library"].libexec.to_s.tr("/", "\\"),
              audit_result: false
    system "dotnet", "publish", "DnsServerApp/DnsServerApp.csproj", *args

    (bin/"technitium-dns").write <<~SHELL
      #!/bin/bash
      export DYLD_FALLBACK_LIBRARY_PATH=#{Formula["libmsquic"].opt_lib}
      export DOTNET_ROOT=#{dotnet.opt_libexec}
      exec #{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{etc}/technitium-dns "$@"
    SHELL
  end

  service do
    run [opt_bin/"technitium-dns", "--stop-if-bind-fails"]
    keep_alive true
    error_log_path var/"log/technitium-dns.log"
    log_path var/"log/technitium-dns.log"
    working_dir var
    environment_variables DNS_SERVER_LOG_FOLDER_PATH: var/"log"
  end

  test do
    dotnet = Formula["dotnet"]
    tmpdir = Pathname.new(Dir.mktmpdir)
    # Start the DNS server
    require "pty"
    dns_cmd = "#{dotnet.opt_libexec}/dotnet #{libexec}/DnsServerApp.dll #{tmpdir}"
    PTY.spawn({ "DNS_SERVER_LOG_FOLDER_PATH" => tmpdir }, dns_cmd) do |r, _w, pid|
      # Give the server time to start
      sleep 2
      # Use `dig` to resolve "localhost"
      assert_match "Server was started successfully", r.gets
      output = shell_output("dig @127.0.0.1 localhost +tcp 2>&1")
      assert_match "ANSWER SECTION", output
      assert_match "localhost.", output
    ensure
      Process.kill("KILL", pid)
      Process.wait(pid)
    end
  end
end
