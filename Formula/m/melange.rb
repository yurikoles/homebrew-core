class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.3.tar.gz"
  sha256 "bd5ad8ebd58d29b17eceee66e3bd64bea5c52363ebdb591f1db89cb0ebd48aa4"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74d17382fd3ba1462b9f9afaa52ccd7b9bbd2860f1d043e6ecf5565e82b9362d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba337e11215d7657a47d40b3a26cd2bdb3ffdc2fa3347a36f566e057f7630932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8ab42baa2cf8978c4e9998cc95a384decb9be638f715ad460399fe23abdee2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "675286d9ebe09d528516aa20c658bca875f54987f2d251172c82e86d2c538296"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9316448114eeb5e0ca620f427510e15f51881be0d6757faf71abc04ac5a84f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49de6e43fa43bf164ef15b970906456c86f5afe28655a6c4c571a5d68ba34071"
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
