class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.14.2.tar.gz"
  sha256 "8ffe7da6ed6716b83a7f4ec26b89d680d7afbb390bc3628d68898d3bc36a9d27"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d56074a77028dcfdb9d9d59b2fcd57aad7e2df80c9f99df8f5c4286ef16c3b7f"
    sha256 cellar: :any,                 arm64_sequoia: "bf9b8dbe11fa244c8f7f6b052f12630a38040f9c02d17be2e075306eb98e2b02"
    sha256 cellar: :any,                 arm64_sonoma:  "cbd9e3001b700ea908fe9873fd9b059d634f437818ea3ccc2e38a6fa21195cb8"
    sha256 cellar: :any,                 sonoma:        "50c0d3151e24e96ec77ce11263d701b9c2e911dd4a9eb1fbfb9173cc85777500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f973a7d348b3dc75f6bc4ef3c4d243617103a1e18e42be3c927ca075b8029de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14f3873914b9f6631948386fe1a9ef164d7a5812597e508117aab2ea83f382c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "gmp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Currently using revision in flake.lock
  resource "cadical" do
    url "https://github.com/meelgroup/cadical/archive/25c12aac83fd2f8627ca5c9a82cd864feea8783f.tar.gz"
    version "25c12aac83fd2f8627ca5c9a82cd864feea8783f"
    sha256 "d36995e5bac5feb6503ae76f201a618da26cbca414284a6caf33c71a9a835f54"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadical", "locked", "rev")
      end
    end
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback.git",
        revision: "798d069b99e030ddb4e612fb6ef7ccaaa2d3a5e5"
    version "798d069b99e030ddb4e612fb6ef7ccaaa2d3a5e5"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadiback", "locked", "rev")
      end
    end
  end

  def python3
    "python3.14"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    (buildpath/name).install buildpath.children
    (buildpath/"cadical").install resource("cadical")
    (buildpath/"cadiback").install resource("cadiback")

    ENV.append_to_cflags "-fPIC" if OS.linux?

    cd "cadical" do
      system "./configure"
      system "make", "-C", "build", "libcadical.a"
    end

    cd "cadiback" do
      system "./configure"
      system "make", "libcadiback.a"
    end

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      -DBUILD_PYTHON_EXTENSION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}
      -DMIT=ON
      -Dcadiback_DIR=#{buildpath}/cadiback
      -Dcadical_DIR=#{buildpath}/cadical/build
    ]

    system "cmake", "-S", name, "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    site_packages.install prefix.glob("pycryptosat.*.so")
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~PYTHON
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    PYTHON
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end
