class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org/"
  url "https://github.com/svent/sift/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "8830db8aa7d34445eee66a5817127919040531c5ade186b909655ef274c3e4ce"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a9f002da076b35a37e62503ec58fe1ee19b6800f14467fdb6436de1dc648d9de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "677bc238dc0f303ab31800d2c3695539d2756365937c555a162b20a7c453da2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80ae5c278ab9dcb654474a7a2f0306dc5d96d4de01e73e96b69715aa48eeaad8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbc851806c100acc052be58ce103f0b2b5304a79e22a1331f6541f4f37b88ef9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4d9aa5a4b8c3f188da9966e82d1aee1bae3c530a2180d2fa5a667ce314d00a4"
    sha256 cellar: :any_skip_relocation, ventura:        "676602a4f1fd5a0a903b5094ce0b5e044ca5c2bce6967d680683e7c4a641478c"
    sha256 cellar: :any_skip_relocation, monterey:       "2bf9fe6ef94f951254079c5e6bed757526b4b8bf68e2eeb862fa07c71302a32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5dc83483b444b3850237050f761c8967ce36008114dad661a1424aa6068da3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"test.txt").write("where is foo\n")
    assert_match "where is foo", shell_output("#{bin}/sift foo #{testpath}")
  end
end
