class Shaderc < Formula
  desc "Collection of tools, libraries, and tests for Vulkan shader compilation"
  homepage "https://github.com/google/shaderc"
  license "Apache-2.0"

  stable do
    url "https://github.com/google/shaderc/archive/refs/tags/v2026.1.tar.gz"
    sha256 "245002feccbe7f8361b223545a5654cea69780745886872d7efff50a38d96c66"

    resource "glslang" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "f0bd0257c308b9a26562c1a30c4748a0219cc951"
      version "f0bd0257c308b9a26562c1a30c4748a0219cc951"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']glslang_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end

    resource "spirv-headers" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "04f10f650d514df88b76d25e83db360142c7b174"
      version "04f10f650d514df88b76d25e83db360142c7b174"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']spirv_headers_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end

    resource "spirv-tools" do
      # https://github.com/google/shaderc/blob/DEPS
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "fbe4f3ad913c44fe8700545f8ffe35d1382b7093"
      version "fbe4f3ad913c44fe8700545f8ffe35d1382b7093"

      livecheck do
        url "https://raw.githubusercontent.com/google/shaderc/refs/tags/v#{LATEST_VERSION}/DEPS"
        regex(/["']spirv_tools_revision["']:\s*["']([0-9a-f]+)["']/i)
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "372d9e06a002208c4d7ddfc7e67bbf7fe3d5966f31c3404a003dc41a837209f8"
    sha256 cellar: :any,                 arm64_sequoia: "031f39fb5aa52cbf117f95dc26d2a147fd83040fd12ed4709723eb3765a635a0"
    sha256 cellar: :any,                 arm64_sonoma:  "9a28cc58ee63a9c26170c1ab2fb22ff85529d19b90b65f58864306ae3c62c097"
    sha256 cellar: :any,                 sonoma:        "10f3643dbf87cd29da487f16276ca6260e64c2fed5623baa7ee1a4f89e8a0201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9623a77760fffa38fa4d09106bd2995da14dbc980d33f6146af253449f4a4964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9effa4b6a3ba860fcbe23c9cbc218dc541e7152eb7bf31416322a1289cbbe5dc"
  end

  head do
    url "https://github.com/google/shaderc.git", branch: "main"

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "main"
    end

    resource "spirv-tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "spirv-headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  # patch to fix `target "SPIRV-Tools-opt" that is not in any export set`
  # upstream bug report, https://github.com/google/shaderc/issues/1413
  patch :DATA

  def install
    resources.each do |res|
      res.stage(buildpath/"third_party"/res.name)
    end

    # Avoid installing packages that conflict with other formulae.
    inreplace "third_party/CMakeLists.txt", "${SHADERC_SKIP_INSTALL}", "ON"
    system "cmake", "-S", ".", "-B", "build",
                    "-DSHADERC_SKIP_TESTS=ON",
                    "-DSKIP_GLSLANG_INSTALL=ON",
                    "-DSKIP_SPIRV_TOOLS_INSTALL=ON",
                    "-DSKIP_GOOGLETEST_INSTALL=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <shaderc/shaderc.h>
      int main() {
        int version;
        shaderc_profile profile;
        if (!shaderc_parse_version_profile("450core", &version, &profile))
          return 1;
        return (profile == shaderc_profile_core) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lshaderc_shared"
    system "./test"
  end
end

__END__
diff --git a/third_party/CMakeLists.txt b/third_party/CMakeLists.txt
index d44f62a..dffac6a 100644
--- a/third_party/CMakeLists.txt
+++ b/third_party/CMakeLists.txt
@@ -87,7 +87,6 @@ if (NOT TARGET glslang)
       # Glslang tests are off by default. Turn them on if testing Shaderc.
       set(GLSLANG_TESTS ON)
     endif()
-    set(GLSLANG_ENABLE_INSTALL $<NOT:${SKIP_GLSLANG_INSTALL}>)
     add_subdirectory(${SHADERC_GLSLANG_DIR} glslang)
   endif()
   if (NOT TARGET glslang)
