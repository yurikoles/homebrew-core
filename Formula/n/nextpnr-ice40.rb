class NextpnrIce40 < Formula
  desc "Portable FPGA place and route tool for Lattice iCE40"
  homepage "https://github.com/YosysHQ/nextpnr"
  url "https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.10.tar.gz"
  sha256 "374393094cdf7b2aae415cebf0994840b4a355bb95e89c683ef19f95f0b14dc2"
  license "ISC"
  head "https://github.com/YosysHQ/nextpnr.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "yosys" => :test
  depends_on "boost"
  depends_on "eigen"
  depends_on "icestorm"
  depends_on "python@3.14"

  def install
    icestorm = Formula["icestorm"]
    args = %W[
      -DARCH=ice40
      -DICESTORM_INSTALL_PREFIX=#{icestorm.prefix}
      -DICEBOX_DATADIR=#{icestorm.pkgshare}/chipdb
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ice40/examples"
  end

  test do
    yosys = Formula["yosys"].opt_bin/"yosys"
    icepack = Formula["icestorm"].opt_bin/"icepack"
    cp_r (pkgshare/"examples/blinky").children, testpath
    system yosys, "blinky.ys"
    system bin/"nextpnr-ice40", "--hx1k", "--package", "tq144", "--json", "blinky.json",
                                "--pcf", "blinky.pcf", "--asc", "blinky.asc"
    system icepack, "blinky.asc", "blinky.bin"
  end
end
