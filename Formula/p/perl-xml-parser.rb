class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.48.tar.gz"
  sha256 "6764a078438ee9b82d9fbc8b17c59618ed4297799ba47ac07b51b8052c260989"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec60a07c4bab2bf666214607a1ccc18bfab40712be7f42727921e378d051535d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad3174765f9185ab3ed4c81926b272aeca2bfcfc80eda6287e45742d015b81e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc249672aded8ba613a668eb143448840e1d270bf1c602b803f940ac6b724ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "6773ab09f8cd10b582c7120c2c336a10125caa891127fb039dc095c13665a6ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402c958d28aa3b7cb0a892eef58898de46eeb30e8c75c3aef2965864fdb7ed20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa1f1171cd8d46f113b1459b6bb4e1ae7413abab6927c85ffc786a3eb249b3d"
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
