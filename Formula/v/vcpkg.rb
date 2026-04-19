class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2026-04-08.tar.gz"
  sha256 "90c592ec10643c54365cc98af2ed6791f66b191e87861fc5b3db993d6faa6ae2"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ba16bb8576fa1b09db8952d3c50203568eb62a851dd363c94ed333923d1ae91"
    sha256 cellar: :any,                 arm64_sequoia: "6a5325c398283c7c8b9680b9d3d2b0485ead35ecbbaffeecd72b542eb8142f52"
    sha256 cellar: :any,                 arm64_sonoma:  "67aaa7e0a7f8a897a4825d1fd0bc1871fe46766d00422528b063bc20a165bbac"
    sha256 cellar: :any,                 sonoma:        "76c7f9a208e72b86d4e5c1d25928345c603f1cd12f7ca9cfe8657bd5b1f923dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ed0925f1935f0b29a2fb4d3e32b4ffeedcff9de6421642a7d7f75d4c364b8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f42c8c01a28fd5f6d60c0594a9f9280f5195c2d6909835e04c498beab57af47"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  uses_from_macos "curl"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "include/vcpkg/base/message-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    # GCC 12 may vectorize SHA code into unsupported `eor3` instructions on
    # Linux arm64 builders.
    ENV.append "CXXFLAGS", "-fno-tree-vectorize" if OS.linux? && Hardware::CPU.arm?

    # VCPKG_VERSION is used by upstream for setting the commit hash
    args = %W[
      -DVCPKG_DEVELOPMENT_WARNINGS=OFF
      -DVCPKG_BASE_VERSION=#{version}
      -DVCPKG_VERSION=#{tap.user}
      -DVCPKG_LIBCURL_DLSYM=OFF
      -DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON
      -DVCPKG_DEPENDENCY_CMAKERC=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcpkg --version")
    output = shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end
