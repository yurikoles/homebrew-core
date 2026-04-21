class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/refs/tags/pachi-12.90-homebrew.tar.gz"
  sha256 "786e111a9e2eaf3801ceeebc6f9ae4c21b15c7807992c4894993973b3a5e19cb"
  license all_of: [
    "GPL-2.0-only",
    "BSD-2-Clause", # `caffe`
  ]
  head "https://github.com/pasky/pachi.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:    "3fc9dffa9c09610c0e425d534cfbffbf06ab07ad152c54772d36f7961ce6be33"
    sha256 arm64_sequoia:  "fd4a7a487d1c0d4c7597970a99008f0def56e08ae402d1d63832b0b5d41f2823"
    sha256 arm64_sonoma:   "57b6e6f43f52e5ef856feccee3a1a828872a90fb45a9e72149147ef8aa1e129d"
    sha256 arm64_ventura:  "59b6a51156dc47e96991c92ce1fdd8060a4b9f2789f53ac515d9b08b8f117941"
    sha256 arm64_monterey: "cba618e09fd5920a22b9e96b44aff7daaf2c1de834cc9b30dc1d13e9b3ce9498"
    sha256 sonoma:         "08420848a56934b074a7044ceb0acc38c49c169a0d784b4b5bdf0af3431ba73c"
    sha256 ventura:        "4f2ff8e1819b0982ae09db3be0935c36e38c809795d4b45776076e9a15e0c1d2"
    sha256 monterey:       "8d0c1b96f212172117f2f44d2880d906d043c0601d8a7b1dd4dc796cf8ddc57d"
    sha256 arm64_linux:    "4b29e4d8ee8bf2f28f3aefbcd40f7c3042c14cb9398df6781006ada3e2e7ed51"
    sha256 x86_64_linux:   "eb13f42af4891d563b870f8840182c9b6f99f76dfd7afcfeaf9c1cbf8bff4790"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "wget" => :build
  depends_on "boost" # For caffe
  depends_on "gflags" # For caffe
  depends_on "glog" # For caffe
  depends_on "hdf5" # For caffe
  depends_on "katago"
  depends_on "openblas" # For caffe
  depends_on "protobuf" # For caffe

  resource "caffe" do
    url "https://github.com/BVLC/caffe/archive/refs/tags/1.0.tar.gz"
    sha256 "71d3c9eb8a183150f965a465824d01fe82826c22505f7aa314f700ace03fa77f"

    # Modern-toolchain fixes: drop header-only boost::system, update
    # SetTotalBytesLimit for protobuf 3.6+, replace std::random_shuffle.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/ea0b351d/Patches/pachi/caffe-modern-toolchain.patch"
      sha256 "47c872c831ca1bcabe102fd2a68842d2c80086c9f295328e785814fae189d7a4"
    end
  end

  # Fix glog LogSeverity cast, portable rpath.
  patch :DATA

  def install
    caffe_prefix = libexec/"caffe"

    resource("caffe").stage do
      # Abseil (via protobuf) is not on Caffe's default include path.
      ENV.append_to_cflags "-I#{Formula["abseil"].opt_include}"

      # Caffe's legacy FindGlog doesn't propagate modern glog's compile
      # definitions, leaving GLOG_EXPORT undefined in <glog/flags.h>.
      ENV.append_to_cflags "-DGLOG_USE_GLOG_EXPORT -DGLOG_USE_GFLAGS"

      # Silence warnings-as-errors from pre-C++14 code on modern Clang.
      ENV.append_to_cflags "-Wno-error -Wno-deprecated-declarations -Wno-unused-but-set-variable"

      args = %w[
        -DCPU_ONLY=ON
        -DBUILD_SHARED_LIBS=ON
        -DBUILD_python=OFF
        -DBUILD_python_layer=OFF
        -DBUILD_matlab=OFF
        -DBUILD_docs=OFF
        -DUSE_OPENCV=OFF
        -DUSE_LMDB=OFF
        -DUSE_LEVELDB=OFF
        -DUSE_NCCL=OFF
        -DBLAS=open
      ]
      # Abseil needs C++17 (std::is_same_v, `if constexpr`).
      args << "-DCMAKE_CXX_STANDARD=17"
      # CMake 4 dropped cmake_minimum_required(2.8.7) compatibility.
      args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: caffe_prefix), *args
      system "cmake", "--build", "build", "--target", "caffe"
      # Install only what pachi links against; `cmake --install` would fail
      # on a non-existent tools/caffe target.
      (caffe_prefix/"lib").install Dir["build/lib/libcaffe*"]
      (caffe_prefix/"include").install "include/caffe"
      (caffe_prefix/"include/caffe").install "build/include/caffe/proto"
    end

    katago_model = "g170e-b20c256x2-s5303129600-d1228401921.bin.gz" # from resource of katago formula

    inreplace "Makefile" do |s|
      # Release tarballs lack build.h.git, so short-circuit the git-metadata rule
      # Issue ref: https://github.com/pasky/pachi/issues/78
      if build.stable?
        s.gsub! "build.h: build.h.git", "build.h:"
        s.gsub! "@cp build.h.git", "echo '#define PACHI_GIT_BRANCH \"\"\\n#define PACHI_GIT_HASH \"\"' >>"
      end

      s.change_make_var! "PREFIX", prefix

      s.gsub! "BUILD_KATAGO=1", "BUILD_KATAGO=0"
      s.gsub! "$(KATAGO_MODEL_PATH)", "" # Don't install own model, use katago model
      s.change_make_var! "KATAGO_BINARY", "katago"
      s.change_make_var! "KATAGO_MODEL", katago_model
    end

    ENV["MAC"] = "1" if OS.mac?
    ENV["GENERIC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"
    ENV["CAFFE_PREFIX"] = caffe_prefix.to_s

    system "make"
    system "make", "datafiles"
    system "make", "install"

    # Use opt path to keep the model without revision, not revision when katago is updated.
    ln_s Formula["katago"].opt_pkgshare/katago_model, share/"pachi-go/#{katago_model}"
  end

  test do
    output = pipe_output("#{bin}/pachi -t =500 2>&1", "genmove b\nquit\n", 0)
    assert_match "External engine: KataGo version #{Formula["katago"].version}", output
    assert_match "Loading joseki fixes", output
    assert_match(/^= [A-T][0-9]+$/, output.lines.find { |line| line.start_with?("= ") })

    # Verify dcnn support is compiled
    assert_match "detlef", shell_output("#{bin}/pachi --list-dcnn")
  end
end

__END__
--- a/dcnn/caffe.cpp
+++ b/dcnn/caffe.cpp
@@ -34,7 +34,7 @@
 {
 	google::InitGoogleLogging(argv[0]);
 	google::LogToStderr();
-	google::SetStderrLogging(google::NUM_SEVERITIES - 1);
+	google::SetStderrLogging(static_cast<google::LogSeverity>(google::NUM_SEVERITIES - 1));
 }

 bool
--- a/Makefile
+++ b/Makefile
@@ -268,7 +268,7 @@
 endif

 ifdef CAFFE_PREFIX
-	LDFLAGS  += -L$(CAFFE_PREFIX)/lib -Wl,-rpath=$(CAFFE_PREFIX)/lib
+	LDFLAGS  += -L$(CAFFE_PREFIX)/lib -Wl,-rpath,$(CAFFE_PREFIX)/lib
 	CXXFLAGS += -I$(CAFFE_PREFIX)/include
 endif
