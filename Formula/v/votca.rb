class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://github.com/votca/votca/archive/refs/tags/v2026.tar.gz"
  sha256 "bf5827e93aecdfd040131ef8427f49efac4ea87d30882c2eb83fea16a054fbc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ea2eec9085cfb8e8f8c964828081125904a2c2307ae570859446d8e371a0cd1"
    sha256 cellar: :any,                 arm64_sequoia: "27c12a0e8e59974e9767d725ea90d55d3581d59361c2122396accee241bc58ec"
    sha256 cellar: :any,                 arm64_sonoma:  "db7b0c744bb4e9f31b29060bd1329b7da560b5e05e2d49fbc4975840634031ac"
    sha256 cellar: :any,                 sonoma:        "87c727bb540e8db157ecd161bd32b8d5770a12c9d847ef196021ebe14c921d3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f1fd91d2adac48f6d14ad03b818de5b73a76b5b7b0e63738c6575b5519a7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db9c23d28cb952eb02b554b5d59ceb3c8a0c3abdd6ca536d8293684ee48f1f5e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "eigen" => :no_linkage
  depends_on "fftw"
  depends_on "gromacs"
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"

  uses_from_macos "expat"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=ON",
      "-DENABLE_RPATH_INJECT=ON",
      "-DPYrdkit_FOUND=OFF",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"topol.xml").write <<~XML
      <topology>
        <molecules>
          <molecule name="MOL" nmols="1" nbeads="1">
            <bead name="B" type="B" mass="1.0" q="0.0" resid="1"/>
          </molecule>
        </molecules>
      </topology>
    XML

    output = shell_output("#{bin}/csg_dump --top topol.xml")
    assert_match "I have 1 beads in 1 molecules", output
  end
end
