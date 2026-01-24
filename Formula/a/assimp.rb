class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/refs/tags/v6.0.3.tar.gz"
  sha256 "9be912589023c7d5a6f2b1db8858b689ce815d5eacf0fea82f869708479b1e51"
  # NOTE: BSD-2-Clause is omitted as contrib/Open3DGC/o3dgcArithmeticCodec.c is not used
  license all_of: [
    "BSD-3-Clause",
    "CC-PDDC",   # code/AssetLib/Assjson/cencode.* (code from libb64)
    "MIT",       # code/AssetLib/M3D/m3d.h, contrib/{openddlparser,pugixml,rapidjson}
    "BSL-1.0",   # contrib/{clipper,utf8cpp}
    "Unlicense", # contrib/zip
    "Zlib",      # contrib/unzip
  ]
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5f8cc6c0ac3345cb557e2d453e18f9ca6e0147b794b56bc04d3207409505cad"
    sha256 cellar: :any,                 arm64_sequoia: "f58478b26ba54029b5c9644205979ed21516f61b776f223accb3765e040747b5"
    sha256 cellar: :any,                 arm64_sonoma:  "cdf28581b62235bdc754b3cdb954230f11f310757f5a9b72947985b47a3d47ed"
    sha256 cellar: :any,                 sonoma:        "d95e1b76e05da13e04120ca1b8756a56470c8af589711db6b2af34241fe2369d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f81737d245c3b270d0a465baa3692dea652d3cc4f428b3adab8c04149724ad2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91dd18b68bbaeed8aae853caf5cce9860892cfa23e8f6e7ee0eac9e55d72b4fc"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "zlib"

  def install
    # Ignore error on older GCC
    if ENV.compiler.to_s.start_with?("gcc") && DevelopmentTools.gcc_version(ENV.compiler) < 15
      ENV.append_to_cflags "-Wno-maybe-uninitialized"
    end

    args = %W[
      -DASSIMP_BUILD_TESTS=OFF
      -DASSIMP_BUILD_ASSIMP_TOOLS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", " -S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<~CPP
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    CPP
    system ENV.cc, "-std=c++11", "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<~EOS
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      # Front left
      v -0.5 0 0.5
      # Front right
      v 0.5 0 0.5
      # Back right
      v 0.5 0 -0.5
      # Back left
      v -0.5 0 -0.5
      # Top point (top of pyramid).
      v 0 1 0

      # List of faces:
      # Square base (note: normals are placed anti-clockwise).
      f 4 3 2 1
      # Triangle on front
      f 1 2 5
      # Triangle on back
      f 3 4 5
      # Triangle on left side
      f 4 1 5
      # Triangle on right side
      f 2 3 5
    EOS
    system bin/"assimp", "export", "test.obj", "test.ply"
  end
end
