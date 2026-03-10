class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.45.2.tar.gz"
  sha256 "04d1ddc658a8e7acc928ae08252ba753e886e1bbf5dc2fc495eb83d2a366dfa0"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57123d6da7859a2255d44d4e85feb8037f7fd8e87aadfd9f914d3a57ba260964"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb6e868bbd6f175080b36bf06a04095f520ac55952cc327d9c9e5c320cc30b4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b81f72624cf204f60f19aa3a4cee325537aeffec43244c131a51aec42a81d4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2c3bf4fc9afe8bebca6849d7ee2cf08c928b73117c4cf6c78c2558a33b8e3c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2760a579707f517cdba820c5d9f29a118930e04a6e0a068b8f8e89cc64b6c8d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d77028c795e18fbc0b84d25ecc819e212510a78ecae8eb8c513828c922cf11b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end
