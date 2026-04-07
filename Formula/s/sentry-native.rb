class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.5.tar.gz"
  sha256 "590dc25f6b5049cdcd60a635ec900f11c7df9aa6f4d0def9bd732f28e99901b3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d319cff419d1f5cb5473df81ac0ecfd3c66485c342cb6bd6321a2178a4ff3b2"
    sha256 cellar: :any,                 arm64_sequoia: "da1bd3acc918972c16244bb4893db9cdd44f308a26bcbdb30e6cfb0de9109f81"
    sha256 cellar: :any,                 arm64_sonoma:  "696b48e60edba7acf3c7a6b024bdd47155cca1866a7c83c3b513d08f6eb39f5a"
    sha256 cellar: :any,                 sonoma:        "70bb93d299ef5a6031b1aaf4f569b0a3303ce8d9c2b361e76dfaf8a6f2c09761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a29aaa3eb90c2eefec03d7be5e81615c8d9e22e2b37e56ac0ddadf37ba351dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c632cdae5d66882b4612b70f5322d965c989d28b7d10a254bf30f84e129ef10c"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "47d70322c848012ed801e36841767d7ffb79412d"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad/archive/eb5fa6e8576e79113b21296bd6af7e2a542839db.tar.gz"
    sha256 "2ca344714dd624a5f91e72c2f56a97f33d62e602522be184d55a13fed9381c36"
  end

  resource "crashpad/third_party/mini_chromium/mini_chromium" do
    url "https://github.com/getsentry/mini_chromium/archive/5d060033dbe1595f612a2f506b7988c8d513d32e.tar.gz"
    sha256 "72d7264f6e3b4ef89d16ef8d32bfc0b3b99b19a539a9bedd514191efeed658b4"
  end

  resource "crashpad/third_party/lss/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        revision: "9719c1e1e676814c456b55f5f070eabad6709d31"
  end

  # No recent tagged releases, use the latest commit
  resource "libunwindstack-ndk" do
    url "https://github.com/getsentry/libunwindstack-ndk.git",
        revision: "284202fb1e42dbeba6598e26ced2e1ec404eecd1"
  end

  resource "third-party/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        tag:      "v2024.02.01",
        revision: "ed31caa60f20a4f6569883b2d752ef7522de51e0"
  end

  def install
    resources.each { |r| r.stage buildpath/"external"/r.name }
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sentry.h>
      int main() {
        sentry_options_t *options = sentry_options_new();
        sentry_options_set_dsn(options, "https://ABC.ingest.us.sentry.io/123");
        sentry_init(options);
        sentry_close();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{HOMEBREW_PREFIX}/include", "-L#{HOMEBREW_PREFIX}/lib", "-lsentry", "-o", "test"
    system "./test"
  end
end
