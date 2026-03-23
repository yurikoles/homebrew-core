class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.26.tgz"
  sha256 "2835ee7da76c4af2d1c938cbb41f932b1e84a1b838da59e3fd48b504d3b772bd"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "487598999b9055e2f93022865806bb7b2a7c27086185799f203d6c8f9441fe94"
    sha256                               arm64_sequoia: "7a8e10ab79ae058e5e7c49645047b7fe00651b30be41c014f1a5471d534bc817"
    sha256                               arm64_sonoma:  "7876f2fa017a355ececc6f104856cea5eed916668cb9dd7b7aaaabea83cd43b7"
    sha256                               sonoma:        "d6d08e1a9928eecdb30e524de79d42921ed979e7a0c9d65446d5ce2a49a6df96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94876482947603d227b59aad84fe136c490bac6f5ca627f89e019e21f0aa2df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f917ca68cf4192c7d9a2227adc9d44a2a389cf6bf9e2582e4625a87ce8795e"
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
