class Rvvm < Formula
  desc "RISC-V Virtual Machine"
  homepage "https://github.com/LekKit/RVVM"
  url "https://github.com/LekKit/RVVM/archive/refs/tags/v0.6.tar.gz"
  sha256 "97e98c95d8785438758b81fb5c695b8eafb564502c6af7f52555b056e3bb7d7a"
  license "GPL-3.0-or-later"

  head do
    url "https://github.com/LekKit/RVVM.git", branch: "staging"

    depends_on "cmake" => :build
  end

  depends_on "pkgconf" => :build

  on_macos do
    depends_on "sdl2"
  end

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxkbcommon"
    depends_on "wayland"
  end

  def install
    if stable?
      system "make"
      bin.install Dir["release.*/rvvm_*"].first => "rvvm"
    else
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      bin.install "build/rvvm"
      lib.install "build/librvvm.dylib" if OS.mac?
      lib.install "build/librvvm.so" if OS.linux?
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rvvm -h")

    touch testpath/"test.bin"
    output_log = testpath/"output.log"
    pid = spawn bin/"rvvm", "test.bin", "-nogui", "-verbose", [:out, :err] => output_log.to_s
    sleep 5
    refute_match "ERROR", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
