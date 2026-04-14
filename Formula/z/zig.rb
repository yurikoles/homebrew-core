class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.16.0/zig-0.16.0.tar.xz"
  sha256 "43186959edc87d5c7a1be7b7d2a25efffd22ce5807c7af99067f86f99641bfdf"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0119519d861dfaf85536ac222e22b92b3bcbbc8f9c2225c3dc484b1aea42292"
    sha256 cellar: :any,                 arm64_sequoia: "7990f1e0cf9f960beb0211717d174e3e78dffdb6b85bdce0e1c8dd5e1c223f0d"
    sha256 cellar: :any,                 arm64_sonoma:  "e789bcc9a1f3c1ea7e2b9393fc43574c43ff8772ab721adfa77f5dfd85e47e30"
    sha256 cellar: :any,                 sonoma:        "eab67e48ec351ac9749386366f9f4e79c0371ba804c8373f59ccebc813740c29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36a8af04a9896b574d61bca4f8258fdc46f6ece0c64b92463620cc6b2d72b8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e8a34b67e7fb82e0dd73a2899b1926b1881b74eef829cf531af0b88ca320f9a"
  end

  depends_on "cmake" => :build
  depends_on "lld@21"
  depends_on "llvm@21"
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313

  # NOTE: `z3` should be macOS-only dependency whenever we need to re-add
  on_macos do
    depends_on "zstd"
  end

  conflicts_with "anyzig", because: "both install `zig` binaries"

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  def install
    # Reduce max_rss to build on CI with less than 8GB memory available
    inreplace "build.zig", ".max_rss = 8_000_000_000,", ".max_rss = 6_900_000_000,"

    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    if llvm.versioned_formula? && deps.any? { |dep| dep.name == "z3" }
      # Don't remove this check even if we're using a versioned LLVM
      # to avoid accidentally keeping it when not needed in the future.
      odie "`z3` dependency should be removed!"
    end

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    cpu = case Hardware.oldest_cpu # See `zig targets`.
    when :arm_vortex_tempest then "apple_m1"
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    args = ["-DZIG_SHARED_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{cpu}" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.zig").write <<~ZIG
      const std = @import("std");
      pub fn main(init: std.process.Init) !void {
          try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, world!");
      }
    ZIG
    system bin/"zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    arches = ["aarch64", "x86_64"]
    systems = ["macos", "linux"]
    arches.each do |arch|
      systems.each do |os|
        system bin/"zig", "build-exe", "hello.zig", "-target", "#{arch}-#{os}", "--name", "hello-#{arch}-#{os}"
        assert_path_exists testpath/"hello-#{arch}-#{os}"
        file_output = shell_output("file --brief hello-#{arch}-#{os}").strip
        if os == "linux"
          assert_match(/\bELF\b/, file_output)
          assert_match(/\b#{arch.tr("_", "-")}\b/, file_output)
        else
          assert_match(/\bMach-O\b/, file_output)
          expected_arch = (arch == "aarch64") ? "arm64" : arch
          assert_match(/\b#{expected_arch}\b/, file_output)
        end
      end
    end

    native_os = OS.mac? ? "macos" : OS.kernel_name.downcase
    native_arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch
    assert_equal "Hello, world!", shell_output("./hello-#{native_arch}-#{native_os}")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    C
    system bin/"zig", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c")
  end
end
