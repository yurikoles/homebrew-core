class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/refs/tags/v2.08.tar.gz"
  sha256 "8099b6275c124f662690f2db3581cd2ad4e9ad4e08332288719838ded00d1da5"
  license "GPL-2.0-or-later"
  head "https://github.com/AlDanial/cloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98da5dbf7c3e919ca2852b18771ee89616ce565c77dee9741fae7ddbfa5fe40d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4188eee9b775b155e22cfa70c45df2b98e3873acc2ecde4680b8ad60605167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe4188eee9b775b155e22cfa70c45df2b98e3873acc2ecde4680b8ad60605167"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dea4656e3a2afbd9e1b794a2af5293107474e0d3ddb2effc35d7c22af4f22484"
    sha256 cellar: :any_skip_relocation, sonoma:        "26e3648038206fb1275209efb8ecea59f898935edc39a2664b5bc1aeb558a78c"
    sha256 cellar: :any_skip_relocation, ventura:       "a65608ead2dfd9c37c0b752029d0b1183d6c1f95221f87fce919b082a82ea1fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592d22654dfd545f6145e652023aa00b13c977d0fb9e5ddeffb016ad2e109b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6091233b75cdeb91a58b8aca46b325c9e9b9778c9ac57549a9675f525fdca30d"
  end

  uses_from_macos "perl"

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2024080801.tar.gz"
    sha256 "0677afaec8e1300cefe246b4d809e75cdf55e2cc0f77c486d13073b69ab4fbdd"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Algorithm-Diff-1.201.tar.gz"
    sha256 "0022da5982645d9ef0207f3eb9ef63e70e9713ed2340ed7b3850779b0d842a7d"
  end

  resource "Parallel::ForkManager" do
    url "https://cpan.metacpan.org/authors/id/Y/YA/YANICK/Parallel-ForkManager-2.04.tar.gz"
    sha256 "606894fc2e9f7cd13d9ec099aaac103a8f0943d1d80c2c486bae14730a39b7fc"
  end

  resource "Sub::Quote" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Sub-Quote-2.006009.tar.gz"
    sha256 "967282d54d2d51b198c67935594f93e4dea3e54d1e5bced158c94e29be868a4b"
  end

  resource "Moo::Role" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Moo-2.005005.tar.gz"
    sha256 "fb5a2952649faed07373f220b78004a9c6aba387739133740c1770e9b1f4b108"
  end

  resource "Module::Runtime" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Module-Runtime-0.018.tar.gz"
    sha256 "0bf77ef68e53721914ff554eada20973596310b4e2cf1401fc958601807de577"
  end

  resource "Role::Tiny" do
    url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Role-Tiny-2.002004.tar.gz"
    sha256 "d7bdee9e138a4f83aa52d0a981625644bda87ff16642dfa845dcb44d9a242b45"
  end

  resource "Devel::GlobalDestruction" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/H/HA/HAARG/Devel-GlobalDestruction-0.14.tar.gz"
      sha256 "34b8a5f29991311468fe6913cadaba75fd5d2b0b3ee3bb41fe5b53efab9154ab"
    end
  end

  resource "Sub::Exporter::Progressive" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/F/FR/FREW/Sub-Exporter-Progressive-0.001013.tar.gz"
      sha256 "d535b7954d64da1ac1305b1fadf98202769e3599376854b2ced90c382beac056"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # These are shipped as standard with OS X/macOS' default Perl, but
    # because upstream has chosen to use "#!/usr/bin/env perl" cloc will
    # use whichever Perl is in the PATH, which isn't guaranteed to include
    # these modules. Vendor them to be safe.
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "make", "-C", "Unix", "prefix=#{libexec}", "install"
    bin.install libexec/"bin/cloc"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    man1.install libexec/"share/man/man1/cloc.1"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    C

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
