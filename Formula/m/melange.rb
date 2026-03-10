class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "876e1424d4d28475edae95dc2edea141b6f6ef923b19af76e40974073114c7d3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f78d34c2a2e6932d53b15054be95146b3c68715469eb3122f92ee193286211"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba531e02a9aa0a435ed24192017412c7e96af1758c065328a2ef6de2da742712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "565ceb229e6901c7605ab9724aab1904598882a0b7a715a5cec854eb936ed192"
    sha256 cellar: :any_skip_relocation, sonoma:        "3839d02cca6bdd074e61524b26863de5655b6084c6df9c68f58b1834db7fc47f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4a2bb854b44f3b7d0b7e7af3106bfbfbe689324bf4228b562f5bcd28a5f999f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4471ecef91704f240f441105151ebc771fd4a4f0a0c21eed7b6b61bdd253fc9d"
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
