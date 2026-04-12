class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2026.04.12/kakoune-2026.04.12.tar.bz2"
  sha256 "ce67adc8af7b20550463332c38e389cacfdd80f709e14b9940c127091aab0681"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03936d0c26ebf7cf2b8dcd6bdbfc7e5c91161451613ff9ed6e65a006d56456fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ec390affc0aca70a37bd33a836f66e8f77a96fcc26a37b7777ed5c3f73acba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "336e9e558392f3bb81120d5c375aae69b53616d58040c3ae82b03a01068d0541"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25ce4465344272466a956d0bae5e15fa9e667567a236efbd0bf89554e6cbfdf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "76186fe32293e045547ecc46c5be8ed2c99756a4d6ea9f50f2a0a1028a42641a"
    sha256 cellar: :any_skip_relocation, ventura:       "ab3088baa28ba656c0ff6df2af0e39142505248964c7de5d33b01471269f5f81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b47987edb2a32934aac363d1082478f7fde6cf25c17aad67d25f1c6c77e392a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd10c0b50a1c649bc8512af7615575e9a233277c3ed7780d51dc5daf76820060"
  end

  on_catalina :or_older do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "binutils" => :build
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # See <https://github.com/mawww/kakoune/blob/v2022.10.31/README.asciidoc#building>
  fails_with :gcc do
    version "10.2"
    cause "Requires GCC >= 10.3"
  end

  # Fix to error: no matching function for call to ‘lower_bound`
  # PR ref: https://github.com/mawww/kakoune/pull/5472
  patch do
    url "https://github.com/mawww/kakoune/commit/9d5fb1992e0149130706aa6c9cb3ab474c580597.patch?full_index=1"
    sha256 "3b777df6d6773daeb23cd5fc59a8732fcfbb62294b37c1108ba7e3d8da9524d1"
  end

  def install
    system "make", "install", "debug=no", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"

    assert_match version.to_s, shell_output("#{bin}/kak -version")
  end
end
