class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1368.tar.gz"
  sha256 "3b849fa00654a8d2588969217e93e3cc8c5ba702d33fd2eef01a0f510d44bb45"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b63a4c8a82af9cf46f488515a1dad725a11023bde534d11b526b835e3355446e"
    sha256 cellar: :any,                 arm64_sequoia: "da5a2cd4e1841a273d8606eb43615008352f90c457b946c1e08029fcf99595a7"
    sha256 cellar: :any,                 arm64_sonoma:  "f8d34995b129e0d701890388c7c578f579e306d70bbb99001e7d9e39dcb39916"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5edc021037a22c29d2dee73a202c4aac23de8b553d08b67a2389b69c8e03f509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a444e346c7ba373756820c61896630c700264911302b422266d37c816171b7c"
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
