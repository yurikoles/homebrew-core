class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.24.tar.gz"
  sha256 "56ccef8d26bee02b3e5685d78c5fedc13f336b4ab53af18d97fa8145be9c8f0e"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3145952e3e56d322858fb0d54debceab5dcceccd92820054c7c80d923267e68c"
    sha256 cellar: :any,                 arm64_sequoia: "4c069f2781f1da3466f28138ff73a0f9d928a7028b7c4270cd2ff6fe8cf5a894"
    sha256 cellar: :any,                 arm64_sonoma:  "63e9b088b8ec6058fc4d5961c832d0da7103a5283147b8d51746b69e53c412a6"
    sha256 cellar: :any,                 sonoma:        "fbaec3a182f3b8d6ca0e2811339797f6964f347c6223cf562563b32d21a07d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8f3c057748120774f38157c5a3583d8923a4ac072dd6f1b3b527e4f0853b853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd4afeb790f496a5640ea571a89654304c06edb496db72f151590359bd134ea"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "mcp-toolbox", because: "both install `toolbox` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end
