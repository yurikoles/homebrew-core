class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.4.14.tar.gz"
  sha256 "e7ffe04e2253f02f1adfed28ffef1cfa41321efd248fda59b5500e09ce470c1e"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f4630c3a96df98146abe2912fc9d954e002e6839194d74b2a30e90acd3a4569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf76fed86bf2ad787d3c5e5eb9e12c4d32ca98653d8b272750ceb2bcbc04d6ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14832628c7e78c55a1b73d7560d0cf897b08509f9af16fb37d802cd1414d910e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b545397e732959eb4763e3bbbff6322be95c0f3e46a8c1bc9a38f1c9165e34f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acaf2f3f215e17323b0e1c7d4590fe1e3ce966a8256574ab32c9f280a4e63fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74700678b5f5ca051e692db276c0eb06a898c076ecc52e4a423bfdc42ade45bf"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
