class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.48.tar.gz"
  sha256 "6764a078438ee9b82d9fbc8b17c59618ed4297799ba47ac07b51b8052c260989"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cabcebf3802feb57d19d68387eba1c7cefc4bf40613a5659a8d3a3887133d9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0172a701a5d434f28a3e4f6e74db3242482c45622df5266718cbb0d0e6296149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9593d0a1cac40934bbfc34a96281ea98bcfd0bcb4d79848122cd636000bb9798"
    sha256 cellar: :any_skip_relocation, sonoma:        "2597486c200df8fd609293050e872dc909768c8fe89236ba31b93c1e022dbc38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "788210abae2782fccb7e830a896992c0cccc03724df4038905d8b679a26fc7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb440145a157f5c4b1426c420808ff3c70062624ed2a1e637d45b7f58cf3772c"
  end

  depends_on "perl" # macOS Perl already has the XML::Parser module
  uses_from_macos "expat"

  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
    sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
  end

  def install
    resource("File::ShareDir::Install").stage buildpath/"File-ShareDir-Install"
    ENV.prepend_path "PERL5LIB", buildpath/"File-ShareDir-Install/lib"

    # Homebrew vendors the new configure-time helper but does not package
    # File::ShareDir at runtime, so keep XML::Parser's legacy @INC fallback.
    inreplace "Expat/Expat.pm",
              "use File::ShareDir ();",
              ""
    inreplace "Expat/Expat.pm",
              "eval { $_share_dir = File::ShareDir::dist_dir('XML-Parser') };",
              "eval {\n    require File::ShareDir;\n    $_share_dir = File::ShareDir::dist_dir('XML-Parser');\n};"

    system "perl", "Makefile.PL", "INSTALLDIRS=vendor", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system Formula["perl"].opt_bin/"perl", "-e", "require XML::Parser;"
  end
end
