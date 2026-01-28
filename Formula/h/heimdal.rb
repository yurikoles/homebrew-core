class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://github.com/heimdal/heimdal"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.8.0/heimdal-7.8.0.tar.gz"
  sha256 "fd87a207846fa650fd377219adc4b8a8193e55904d8a752c2c3715b4155d8d38"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause",    # lib/gssapi/mech/
    "HPND-export2-US", # kdc/announce.c
    :public_domain,    # lib/hcrypto/libtommath/
  ]
  revision 1

  livecheck do
    url :stable
    regex(/heimdal[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "b94f54f75fb374686b5a64a556713af292e814be6604967231d82dc8eaaf8000"
    sha256 arm64_sequoia: "2dd0cd88b20557be8d0a1cf8e7ea0d3a32804d0d0f6393a28a265bb57a9d699f"
    sha256 arm64_sonoma:  "6db752f524be624dbb90053d8ccf743b4cf9ae455faadceb5d6fdb03dcee54f8"
    sha256 sonoma:        "ee5f409471c9e71e1806d1da4b9f58cbff009cf6c2334e8ab70e0d1ff457ef64"
    sha256 arm64_linux:   "be99b3cda9fa62786dc9a98397304f2e59813d91e574ddb879ee3c7cba820680"
    sha256 x86_64_linux:  "07e0ed255ed4f2cf243aa534122ea42ac7b99655ca56a8dfc7e058c5a5a953a0"
  end

  keg_only "it conflicts with Kerberos"

  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  resource "JSON" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath/"perl5/lib/perl5"

      resource("JSON").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/perl5"
        system "make"
        system "make", "install"
      end
    end

    args = %W[
      --without-x
      --enable-pthread-support
      --disable-afs-support
      --disable-ndbm-db
      --disable-heimdal-documentation
      --disable-silent-rules
      --disable-static
      --with-openldap=#{Formula["openldap"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-hcrypto-default-backend=ossl
      --with-berkeley-db
      --with-berkeley-db-include=#{Formula["berkeley-db@5"].opt_include}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "-L#{lib}", shell_output("#{bin}/krb5-config --libs")
  end
end
