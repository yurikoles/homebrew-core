class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1464.tar.gz"
  sha256 "7eaee28efcb82d5df755288899dd9b8a44df95b8a7f4e5bb8be4cd76270387b8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0478fb9af8becb6bda375f98e38bb89557cd6fb0b508a3f828e3ee069f05ba3"
    sha256 cellar: :any,                 arm64_sequoia: "d5f07745a174ed9ba93ce4c8370fca10936c4fc7b46ea41e450748d61195c983"
    sha256 cellar: :any,                 arm64_sonoma:  "be54f3dab9a4d1afeec04edd2390381610258c9febfb324761ea27b68ee43ce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e384634b3bba287abde324566715ad26bfb0b32e1a1ae57f10cd82f893b786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a8e3c39bce40c91a91dfacab63448528f167c1883dbb171af3543e9397f5a43"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
