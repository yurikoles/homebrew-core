class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.9.tar.gz"
  sha256 "d7bcc7dedecf308863eb487c83f0bf8a69279fded8eb08e59d9fbb0ffd4e9bbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8a4b6e938b44a0a5b4170a1411ea82818c9e27784c3057838c84ffba30b7dd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97b957e4326155373669a97877859a4c44cb106170b7632863062f940969e4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bbece600e7f72755f90b84d515648104aca34e61868373ee7afb76adbe420ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c3ade1a82346b54052f5a6e70681e0e58dbc34ecc689e42dba4e6c7ed8d5043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11e0c7ddce4833adc60bddd4b4f599019b6dc81cddc69daf1652a5d5fa5f337a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0357e172d98ada703f2a7c538c25d4352ca307996685585d381aaea0329270b"
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
