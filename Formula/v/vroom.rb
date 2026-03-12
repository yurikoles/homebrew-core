class Vroom < Formula
  desc "Vehicle Routing Open-Source Optimization Machine"
  homepage "http://vroom-project.org/"
  url "https://github.com/VROOM-Project/vroom.git",
      tag:      "v1.15.0",
      revision: "43dd7d0b8b560431eb555bf335cf4797eb7343c4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "603f9db571c5a11951f2d2f7a07e4a1108c07798cd1f347dbf4736e6baf6d7b3"
    sha256 cellar: :any,                 arm64_sequoia: "e6cb0a6729f091b1d219c0ba4bfb995dfd3e2e2a445091550743ed273e1c5812"
    sha256 cellar: :any,                 arm64_sonoma:  "a536b93c09c30d3c6ba2970a4b5dbb00dc0b1b87d9edc006b1d639129ecf113c"
    sha256 cellar: :any,                 sonoma:        "e4173177423d3cc154d5a13b740793bd9045ad5c410e224e91766d35a8fa1b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c01b046eb63ab22c7567f7ecfe3f48dabdb17f410658184e11eecf32ddb5ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7e36a54cfde07f9cf24edfdc3ff570621414264cd20f4d4b9a83c2e9b8dab3"
  end

  depends_on "asio" => :build
  depends_on "cxxopts" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "openssl@3"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_sequoia do
    depends_on xcode: ["26.0", :build] if DevelopmentTools.clang_build_version >= 1700
  end

  on_linux do
    depends_on "gcc" # TODO: remove and rebuild bottle on Ubuntu 24.04
  end

  fails_with :clang do
    build 1699
    cause "needs C++20 std::jthreads"
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  # Apply open PR to fix missing include
  # PR ref: https://github.com/VROOM-Project/vroom/pull/1333
  patch do
    url "https://github.com/VROOM-Project/vroom/commit/3bd437aa5951040593d535336a3d7cf86b6ac405.patch?full_index=1"
    sha256 "f9681c0d96265435e3b15477ec9471116159716a2a868b33e4d46eb1009cd1dd"
  end

  def install
    # Use brewed dependencies instead of vendored dependencies
    cd "include" do
      rm_r(["cxxopts", "rapidjson"])
      mkdir_p "cxxopts"
      ln_s Formula["cxxopts"].opt_include, "cxxopts/include"
      ln_s Formula["rapidjson"].opt_include, "rapidjson"
    end

    files = %w[
      src/routing/http_wrapper.h
      src/utils/input_parser.cpp
      src/utils/output_json.cpp
      src/utils/output_json.h
    ]
    inreplace files, "../include/rapidjson/include/rapidjson", "rapidjson"

    system "make", "-C", "src"
    bin.install "bin/vroom"
    pkgshare.install "docs"
  end

  test do
    output = shell_output("#{bin}/vroom -i #{pkgshare}/docs/example_2.json")
    expected_routes = JSON.parse((pkgshare/"docs/example_2_sol.json").read)["routes"]
    actual_routes = JSON.parse(output)["routes"]
    assert_equal expected_routes, actual_routes
  end
end
