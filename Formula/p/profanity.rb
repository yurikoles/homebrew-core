class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.17.0.tar.xz"
  sha256 "508e18c0e797d46cc38779eb207480fc3e93b814e202a351050f395c1b262804"
  license "GPL-3.0-or-later"
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "669b57ae421eea14e623d6306d16f62f8a3e7e5ac52fc69b6283d4a15f79ca9d"
    sha256 arm64_sequoia: "477f46a2c063e66a2b912ca2788500d6647072933488d7c4f57c49152f53966f"
    sha256 arm64_sonoma:  "20dd11d5c66e8b6470b58c8ef658144c2a02cfbf8498ec265337052a4b51d435"
    sha256 sonoma:        "7d238042c8a6f2c67b8ff2bbf60e4e2902212976c613257fb2cd5adb39c6f061"
    sha256 arm64_linux:   "bbfb37674269d2c6acd616e77c6022e346181b7093fb30b05e1c60343d48dffd"
    sha256 x86_64_linux:  "b041c981823cfc9d4bb96e6d78b49a040834b1cbbb6bdf5e759ec9b5b4824ee6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "gtk+3"
  depends_on "libgcrypt"
  depends_on "libomemo-c"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "libx11"
  depends_on "libxscrnsaver"
  depends_on "python@3.14"
  depends_on "qrencode"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    depends_on "libnotify"
  end

  # Fix missing imports for libomemo-c support: https://github.com/profanity-im/profanity/pull/2133
  patch do
    url "https://github.com/profanity-im/profanity/commit/9a501e6ecdaf65d28362e5888a0529fb734a353e.patch?full_index=1"
    sha256 "ac0f514496890bbcbed9cee3f6a84387c64f3a299d9b2f700e07ae57bb887447"
  end

  def install
    # Meson shells out to `brew --prefix readline` on macOS if `dependency("readline")`
    # cannot resolve directly, so keep Homebrew's `brew` executable discoverable.
    ENV.prepend_path "PATH", File.dirname(HOMEBREW_BREW_FILE)

    args = %w[
      -Dnotifications=enabled
      -Dpython-plugins=enabled
      -Dc-plugins=enabled
      -Dotr=enabled
      -Dpgp=enabled
      -Domemo=enabled
      -Domemo-backend=libomemo-c
      -Domemo-qrcode=enabled
      -Dicons-and-clipboard=enabled
      -Dgdk-pixbuf=enabled
      -Dxscreensaver=enabled
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"profanity", "-v"
  end
end
