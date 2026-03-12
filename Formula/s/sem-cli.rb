class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://github.com/Ataraxy-Labs/sem"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "08453cf7809510148db7c12c370bba18bd709aa15a38026aebd56d7f5e039bfa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f692d81a0741094890c34d4e16519ec3504860665765ff4c7d7cd5fb8ef97a5"
    sha256 cellar: :any,                 arm64_sequoia: "35f6547d13dc866cf518ebcb4837fe75b233ac0745a64e4455e3acb26f62901d"
    sha256 cellar: :any,                 arm64_sonoma:  "a54dae5cf3568fb67843415d531d6c6d2f6cf22b41a23330b4d2e4fcea7629fb"
    sha256 cellar: :any,                 sonoma:        "09949255fd0d872511deaec05bc43238e611474869f090e330df181e440d4355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54023360ab2621af8b2b5f6cbc308936a05b194d39fdb1de3bbcfab2d6278f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d25829a47355f6b56e16d2f06829355adab7a44b56bc83ec92c348efbdbb113"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    assert_match "sem #{version}", shell_output("#{bin}/sem --version")

    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "hello.py"
    system "git", "-C", testpath, "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "-C", testpath, "add", "hello.py"
    system "git", "-C", testpath, "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
