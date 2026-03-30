class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.38.3.tar.gz"
  sha256 "9e8922d2a900f7a18644892f5c6aec8cc8f3046d1ee3fdd96714f792c310ea8b"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a09b3472a3b5cb31d3b5392c186117a9f398508a940b8dd16b655bca8312bec"
    sha256 cellar: :any,                 arm64_sequoia: "7b93f6864e108913cfd7a1673301c9e57860c201647de599441acdcc599f42dc"
    sha256 cellar: :any,                 arm64_sonoma:  "b4b2676a407a9558bb9ad5d88535836f842995deeae984dd98bd04b8288ae8ec"
    sha256 cellar: :any,                 sonoma:        "3db233324f97562dfd20752716fdd994971ba5a673f8d71b0e713132e26ee095"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "490cdd0b870f1587c09b64751535752a38bc2bb2859fa7430cdf79b648a5682d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12379e0c3353f6adff3367553ea5f9a6b3b232b432c4c94d3492bb14497ebb2d"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"

  def install
    args = %W[
      -DBUILD_DEPS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake
    ]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <aws/crt/Allocator.h>
      #include <aws/crt/Api.h>
      #include <aws/crt/Types.h>
      #include <aws/crt/checksum/CRC.h>

      int main() {
        Aws::Crt::ApiHandle apiHandle(Aws::Crt::DefaultAllocatorImplementation());
        uint8_t data[32] = {0};
        Aws::Crt::ByteCursor dataCur = Aws::Crt::ByteCursorFromArray(data, sizeof(data));
        assert(0x190A55AD == Aws::Crt::Checksum::ComputeCRC32(dataCur));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-laws-crt-cpp"
    system "./test"
  end
end
