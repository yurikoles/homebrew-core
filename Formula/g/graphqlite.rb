class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "1886f9f817500fcbbf47fe957bde54eb7d6c34a19de5fd9f9568249903c8d879"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d899627e611b6068586864e38e5ff96f20f06fe2b8dca9ddb37090ac37588d3"
    sha256 cellar: :any,                 arm64_sequoia: "4eea3effee0a6bce6e27a05f1fd47d36bf74fce2b77f245b4b3d28dbb475663a"
    sha256 cellar: :any,                 arm64_sonoma:  "3d4a0f026aabc6c406326655c7ca94827cc3024eeeff8ccede9f1cd0e6508bfd"
    sha256 cellar: :any,                 sonoma:        "9bc322491a4b2c5d3876d266f5a23a48da276ad177b59d14e49dc74bae9a74c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dcbf3ff9df60ca12444acddef5a3e9bfbb54ddb86aa307fc8f6239e1cd0a542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68a212ce7f3707ffb24e07cbf752180dc0e859760b70e6db5ffaddc816b50654"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "sqlite"          # macOS sqlite can't load extensions

  uses_from_macos "flex" => :build

  def install
    system "make", "extension", "RELEASE=1"
    lib_ext = OS.mac? ? "dylib" : "so"
    (lib/"sqlite").install "build/graphqlite.#{lib_ext}"
  end

  def caveats
    <<~EOS
      The SQLite extension is installed in #{opt_lib}/sqlite.
      To load it in the SQLite CLI:
        .load #{opt_lib}/sqlite/graphqlite
    EOS
  end

  test do
    sql = <<~SQL
      .load #{opt_lib}/sqlite/graphqlite
      -- Create people
      SELECT cypher('CREATE (a:Person {name: "Alice", age: 30})');
      SELECT cypher('CREATE (b:Person {name: "Bob", age: 25})');
      SELECT cypher('CREATE (c:Person {name: "Charlie", age: 35})');

      -- Create relationships
      SELECT cypher('
          MATCH (a:Person {name: "Alice"}), (b:Person {name: "Bob"})
          CREATE (a)-[:KNOWS]->(b)
      ');
      SELECT cypher('
          MATCH (b:Person {name: "Bob"}), (c:Person {name: "Charlie"})
          CREATE (b)-[:KNOWS]->(c)
      ');

      -- Query friends of friends
      SELECT cypher('
          MATCH (a:Person {name: "Alice"})-[:KNOWS]->()-[:KNOWS]->(fof)
          RETURN fof.name
      ');
    SQL
    assert_match '{"fof.name": "Charlie"}', pipe_output("#{Formula["sqlite"].opt_bin}/sqlite3", sql)
  end
end
