class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.12.tar.gz"
  sha256 "5889ff5d2cc386b07c8320bfc4a7a949d8b25e9e21c15cea3ea121337083a49b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebce688acee45897a6f80e861ae5bfde1c07ec88bdf97a4a715dba7954702fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d394d0266b4c7b1349662413ff318dad01b6d7f91574599b8f7365f7f87a1eaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dd4d6f96a7f9973c75a4cc3ec20e47091bd1871bc31dac21dc1f974f16fefbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "99990b03324297124704572044a23ed2206e112bedecf9c8f2d7a5c87ce148ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feb4bbaf5f39aff8144ead7cdf7cf67aa79c63ddc3cf460e230163bfd348b5fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc43f1ffc48fefc320842d2fbc41a65f2fcf4c49ffa011a31ded8600ce4641cc"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    mkdir_p [libexec, bin]

    # ocicl's setup.lisp generates an executable that is the binding
    # of the sbcl executable to the ocicl image core.  Unfortunately,
    # on Linux, homebrew somehow manipulates the resulting ELF file in
    # such a way that the sbcl part of the binary can't find the image
    # cores.  For this reason, we are generating our own image core as
    # a separate file and loading it at runtime.
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit",
           "--eval", "(load \"runtime/asdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~LISP
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
