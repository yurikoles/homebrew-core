class Fnox < Formula
  desc "Fort Knox for your secrets - flexible secret management tool"
  homepage "https://fnox.jdx.dev/"
  url "https://github.com/jdx/fnox/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "4f47efbbbfeb50a6f5dae2547f77ea70fa2000027b53911ca52254309e3d402f"
  license "MIT"
  head "https://github.com/jdx/fnox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62fbdc35a4253ee965cbe38a46aac95f5cd307f647e4466c156a2bfa26fd4d05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d2db8f5e864ab383771e9d183434bea752f118fb14e12f118c693e56ad3f1e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f82a4cd3eb009ae5607606cf3e7253d55d106e692fa1719abce1e46991b62f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "f150f67259c417bbc7b03a131da320e88116f22f7454ced22858fdc16676b174"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0dcb98f434916264a2c908cd586f6270e94c395672494b5c4dd3fa4de73848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da224ea98f42b6b5f32a676bbe4bb41b1df1019bbd169a5195046dc31e76395e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "age" => :test
  depends_on "usage"

  on_linux do
    depends_on "openssl@3"
    depends_on "systemd" # libudev
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fnox --version")

    test_key = shell_output("age-keygen")
    test_key_line = test_key.lines.grep(/^# public key:/).first.sub(/^# public key: /, "").strip
    secret_key_line = test_key.lines.grep(/^AGE-SECRET-KEY-/).first.strip

    (testpath/"fnox.toml").write <<~TOML
      [providers]
      age = { type = "age", recipients = ["#{test_key_line}"] }
    TOML

    ENV["FNOX_AGE_KEY"] = secret_key_line
    system bin/"fnox", "set", "TEST_SECRET", "test-secret-value", "--provider", "age"
    assert_match "TEST_SECRET", shell_output("#{bin}/fnox list")
    assert_match "test-secret-value", shell_output("#{bin}/fnox get TEST_SECRET")
  end
end
