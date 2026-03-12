class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.22.1.tar.gz"
  sha256 "2f6891c32d85e52fea11645b273670f99bade9ebf6b90f2a90eb4c3560a38969"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7677d135c6de86bb4949273088603bb4d620332a89f306116486beec89127fb5"
    sha256 cellar: :any,                 arm64_sequoia: "9a1928d9760536b9fffcbb4d57fe08fdfb6902e3795fb7c983ff21296f8e9c66"
    sha256 cellar: :any,                 arm64_sonoma:  "437980d0fb0b96270ce0fda7036dbb93e5fa4c45a294870ecedfbbf24844a1b7"
    sha256 cellar: :any,                 sonoma:        "06a0d4ad6d1d6b79456a489e56eb33370e970e2c134be034d335fda7e6cc85a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9fc920284d9eb15f9ba72c4503e6db149bb21aa15531f6ccca00d968fc396bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50f3e72fc61766bd624a26c7afd208d10f4a775d0cd00e0dee296c3ed81207e0"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

  def install
    ENV["PGLS_VERSION"] = version.to_s
    ENV["LIBPG_QUERY_PATH"] = Formula["libpg_query"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "crates/pgls_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgres-language-server check #{testpath}/test.sql", 1)
    assert_includes output, "Checked 1 file"
    assert_match version.to_s, shell_output("#{bin}/postgres-language-server --version")
  end
end
