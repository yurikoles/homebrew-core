class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "5b17329320920f7b962efa1d91b1dad3e4c96f6d43ff764a85b774c69516dca0"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ebf3f713776b5af5e11e12bdd5eef9607dbad4ad9cccb9b5ddba674e3f074f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc1f5d95d875beafdce89543ecd8abcc1a5c92d6027b2b726686beadbbaf822"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f550bdb15a4d35000b74faee61a4b1dd12a8e20bdc864c7c3869e248f7e2b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b350411b921fb785a55697b3e38d1460890bdabdd7dd8118aed0fcafefea8146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a81af58e65beac38f84f1ec7e84d1e2f56fc53cfbdbe8b31b8d7f51dc4ff57c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f92bce922834616ee90a4431e1f942c96b5385c735265111ab6827f95ad87a"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized '#{project}' successfully", shell_output("#{bin}/helix init")

    assert_path_exists testpath/"helix.toml"
    assert_path_exists testpath/"db"
    assert_path_exists testpath/"db/queries.hx"
    assert_path_exists testpath/"db/schema.hx"

    assert_match "Added '#{project}' successfully", shell_output("#{bin}/helix add local 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local 2>&1", 1)

    (testpath/"db/schema.hx ").write "N::User { name: String }"
    assert_match "error: helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
