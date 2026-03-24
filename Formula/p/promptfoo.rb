class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.2.tgz"
  sha256 "bc01fa1d55bb4370891ba23f7eea70c85225f2b8250cadf101018022bcc11f41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a4effa66df494d5b59113ca069ee4b50dd323d2c39468134eab2257eef40ca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057edb30dbdde95477a3c9aebe69701a75b3491a0f6fe0141d3a02412df8685f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1740193b6f389996240f9503f24a14609709a66ba56d59458a0ece403a3fcdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "580a605923b6cf6ffe4b2dc4c080d4084a0d9d2cc319bc472aa42d7493126016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97c4f2576cf36b18322e32c37b40359ab1445481b33a6a9e37836aa00123544e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a297c54010b14ad901289756cb717a977ce64839d4ea0196188aacf009b2b6e5"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  fails_with :clang do
    build 1699
    cause "better-sqlite3 fails to build"
  end

  def install
    # NOTE: We need to disable optional dependencies to avoid proprietary @anthropic-ai/claude-agent-sdk;
    # however, npm global install seems to ignore `--omit` flags. To work around this, we perform a local
    # install and then symlink it using `brew link`.
    (libexec/"promptfoo").install buildpath.children
    cd libexec/"promptfoo" do
      system "npm", "install", "--omit=dev", "--omit=optional", *std_npm_args(prefix: false)
      system "npm", "run", "--prefix=node_modules/better-sqlite3", "build-release"
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
