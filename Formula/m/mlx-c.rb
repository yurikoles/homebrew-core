class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c/build/html/index.html"
  url "https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6ec2eab86ed3ce661c0d9b834027870651546138b7b4470fa8ef5533498c79aa"
  license "MIT"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "83d092eb6a813c680997c13cafaff9cf6559be17f94eaa80f4aa503dd5e6b8f0"
    sha256 cellar: :any, arm64_sequoia: "721c3c05e50cf23350c725d4b3855ab8fe2ff7265b9e2d61e951b730fe5b2b5b"
    sha256 cellar: :any, arm64_sonoma:  "03127804f9796dfa15b14e4e4faaa19420a182377441a98275fd855ab32fe973"
  end

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on :macos
  depends_on "mlx"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  # support for mlx_distributed_group_free() (#110)
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/1e3c24ffebfdfbeecca054c51637fc4381d98aab.patch?full_index=1"
    sha256 "24831d5bc44b72a0fd027572a4e4eaf754ed9805ffed86185bb8dbdfb6284818"
  end

  # support for gguf (#111)
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/89d3454ac3f46ff68668dd9f7817c6d47650e47c.patch?full_index=1"
    sha256 "411749fd1908fdee783c3b378471603606852ce3a0ee0011ca5b66f47187b9d3"
  end

  # support for graph export (#112)
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/782d4712862b247a094086419ce130fd82cf3c53.patch?full_index=1"
    sha256 "4469b3ec2836efeadce98a192ae26f423cdbbd182edcd2126f4a6ef36891ce58"
  end

  # regenerate bindings for MLX 0.31.2 (#114)
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/fba4470b89073180056c9ea46c443051375f7399.patch?full_index=1"
    sha256 "5102eafc68ea94cbe8cabb4acaa9905e17d1c92cb6a1b8c7f0f73dc863c09609"
  end

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DMLX_C_BUILD_EXAMPLES=OFF
      -DMLX_C_USE_SYSTEM_MLX=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-o", "test", "-L#{lib}", "-lmlxc"
    assert_match "array([0, 0.5, 1, 1.5, 2, 2.5], dtype=float32)", shell_output("./test")
  end
end
