class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://github.com/ggml-org/ggml/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a344050fc15b0307826a6b0b480eda4b45bd6c5cdbe974cec6840be2c3b6c7d0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "df416e439f8bd8ad13e51117f2cfc4d27d9e4a131539df232ed284a0b36fbfe4"
    sha256 arm64_sequoia: "cd2bfda0462dab3ea8186868aa654eb5825788090e1467fb0b96b74a4263c208"
    sha256 arm64_sonoma:  "879bba174ff0c1cf722136914ec757cd369c99b4804da3c723972db798ea8d22"
    sha256 sonoma:        "ebbe28048543384ee0e6a8136d42e551b9ae23ed16cc2038785d3fe01768d2d1"
    sha256 arm64_linux:   "c7421cb5d7d6ca009aeb2d7f06f7788da2c67590803623e282aa758689c616cf"
    sha256 x86_64_linux:  "6dfe5ece36094fdc25c09b59e8b6bad4b55edeb58ff8a3fdad85c99a4fa58434"
  end

  depends_on "cmake" => [:build, :test]

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "shaderc" => :build
    depends_on "openblas"
    depends_on "spirv-headers"
    depends_on "vulkan-loader"
  end

  # These were previously provided by `llama.cpp`
  link_overwrite "include/ggml*", "include/gguf.h", "lib/cmake/ggml/", "lib/libggml*"

  # Lengthy test so not worth installing. Shorter examples/tests haven't been ported to new DL backend
  resource "test-backend-ops.cpp" do
    url "https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.10.0/tests/test-backend-ops.cpp"
    sha256 "99e600136c9d49db24b624a181ca056cd8924140f04321e47b9c3b45143b6f67"

    livecheck do
      formula :parent
    end
  end

  def install
    # CPU detection is needed to build multiple backends, particularly on ARM (e.g. `-march=armv8.x-a+...`)
    ENV.runtime_cpu_detection

    # TODO: Workaround for GCC 12 as armv9.2-a was added in GCC 13. Remove after Ubuntu 24.04 migration
    if Hardware::CPU.arm? && ENV.compiler.to_s.start_with?("gcc") && DevelopmentTools.gcc_version(ENV.compiler) < 13
      inreplace "src/ggml-cpu/CMakeLists.txt", "if (GGML_INTERNAL_SME)", "if (OFF)"
    end

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BACKEND_DIR=#{libexec}
      -DGGML_BACKEND_DL=ON
      -DGGML_BLAS=ON
      -DGGML_BUILD_EXAMPLES=OFF
      -DGGML_BUILD_TESTS=OFF
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_NATIVE=OFF
    ]

    # Enabling OpenBLAS for BLAS support and Vulkan for GPU support on Linux
    args += %w[-DGGML_BLAS_VENDOR=OpenBLAS -DGGML_VULKAN=ON] if OS.linux?

    # Not building Metal backend and CPU variants on Intel macOS
    if OS.mac? && Hardware::CPU.intel?
      args += %w[-DGGML_METAL=OFF -DGGML_METAL_EMBED_LIBRARY=ON]
    elsif build.bottle?
      args << "-DGGML_CPU_ALL_VARIANTS=ON"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("test-backend-ops.cpp")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(ggml REQUIRED)
      add_executable(test test-backend-ops.cpp)
      target_link_libraries(test PRIVATE ggml::ggml)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_match(/[1-9] backends passed/, shell_output("./build/test -o ABS"))
  end
end
