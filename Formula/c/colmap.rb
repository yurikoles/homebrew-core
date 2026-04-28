class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/4.0.4.tar.gz"
  sha256 "200309abca2a3ee05970b1f8a48d545fc71f435dffe6764a8040f9f6f364da32"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "8fa7ebd6e0cdd283a6f7a4d9bc78f342515a61f1f2c2ac50cbb58a93347dd50f"
    sha256                               arm64_sequoia: "074439005cf0ccd623004c7de0c42a2461f3a23abbf7b7939c278c0e3d3c6ae5"
    sha256                               arm64_sonoma:  "92d33133dd59b65e225e4d77f7d590154a21b34027cc00671febcd7ac37db45c"
    sha256 cellar: :any,                 sonoma:        "43ac44eaae992dae1a0d440180269a2a9f8c6a47f472d34f3b715350e823714e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb29a06891d81b302da527bce09afc4ac714005346167ffc4ed8b1b535e6b6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d36dc15e6fbbb6d064b628c9dcd771b7b880c03db6e7fcb85c3908523af11e9"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen" => :no_linkage
  depends_on "faiss"
  depends_on "flann"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "onnx"
  depends_on "onnxruntime"
  depends_on "openimageio"
  depends_on "openssl@3"
  depends_on "poselib"
  depends_on "qtbase"
  depends_on "suite-sparse"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "mpfr"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
      -DFETCH_FAISS=OFF
      -DFETCH_ONNX=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    # Fix library install directory and rpath
    inreplace "CMakeLists.txt", "LIBRARY DESTINATION thirdparty/", "LIBRARY DESTINATION lib/"
    args << "-DCMAKE_INSTALL_RPATH=#{loader_path}"
    # Set openssl@3 to avoid indirect linkage with openssl@4
    # TODO: switch to openssl@4
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
