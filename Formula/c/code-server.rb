class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/coder/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-4.110.1.tgz"
  sha256 "11307192d13e24f8892dacc20f47f09a15a8637da5c5285e2d3e25b0941d3632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba118f961f4bca617a3591f24cdcde944d52a3cc108681be050213a73a3636c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9eed8e68145aefad367f7a51ea1876f449468aaf7d756f06fbea0110cdb8d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "642c647d426eb660a83f65f71edf51960d1cecee998a3b9e1b369fa04cf4b935"
    sha256 cellar: :any_skip_relocation, sonoma:        "07409fb0184af7bc7c4a028822dcf0c3dad551daa25ebda57052996d63a54fe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70861354877af85c0feb92ff9e966132576b6a7cae1a566fe15d0b1b7f8e6039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7d9d64bd800e8f1cdab9568fe7be1ff97e47fab95164f22f9d58d9376a6841"
  end

  depends_on "pkgconf" => :build
  depends_on "node@22"
  uses_from_macos "python" => :build

  on_linux do
    depends_on "krb5"
    depends_on "libsecret"
    depends_on "libx11"
    depends_on "libxkbfile"
  end

  def install
    # Fix broken node-addon-api: https://github.com/nodejs/node/issues/52229
    ENV.append "CXXFLAGS", "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT"

    system "npm", "install", *std_npm_args(ignore_scripts: false, prefix: false), "--unsafe-perm", "--omit", "dev"

    libexec.install Dir["*"]
    bin.install_symlink libexec/"out/node/entry.js" => "code-server"

    # Remove pre-built binaries which are unused as a source-built binary is available
    rm_r(libexec/"node_modules/argon2/prebuilds")

    # Remove non-native binaries
    arch = Hardware::CPU.intel? ? "arm64" : "x64"
    anthropic_node_modules = libexec/"lib/node_modules/@anthropic-ai/node_modules"
    vscode_node_modules = libexec/"lib/vscode/node_modules"
    rm_r(vscode_node_modules.glob("@anthropic-ai/sandbox-runtime/dist/vendor/seccomp/#{arch}"))
    rm_r(vscode_node_modules.glob("@anthropic-ai/sandbox-runtime/vendor/seccomp/#{arch}"))
    rm_r(anthropic_node_modules.glob("@parcel/watcher-{darwin,linux}*"))
    rm_r(vscode_node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    # Remove pre-built binaries where source in not available to allow compilation
    # https://www.npmjs.com/package/@azure/msal-node-runtime
    # https://github.com/AzureAD/microsoft-authentication-library-for-cpp
    dist = libexec/"lib/vscode/extensions/microsoft-authentication/dist"
    rm([dist/"libmsalruntime.so", dist/"msal-node-runtime.node"])
  end

  def caveats
    <<~EOS
      The launchd service runs on http://127.0.0.1:8080. Logs are located at #{var}/log/code-server.log.
    EOS
  end

  service do
    run opt_bin/"code-server"
    keep_alive true
    error_log_path var/"log/code-server.log"
    log_path var/"log/code-server.log"
    working_dir Dir.home
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/code-server --version")

    port = free_port
    output = ""

    PTY.spawn "#{bin}/code-server --auth none --port #{port}" do |r, _w, pid|
      sleep 3
      Process.kill("TERM", pid)
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    ensure
      Process.wait(pid)
    end
    assert_match "HTTP server listening on", output
    assert_match "Session server listening on", output
  end
end
