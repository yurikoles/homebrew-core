class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.16.1",
      revision: "de4700e9f6b75b109910613df907965e3cbe0567"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccde649fd195eb965e10027b0ad739b2b2a0c43028db67cac8965f3fc677d369"
    sha256 cellar: :any,                 arm64_sequoia: "3ea45c5dd581589e0289c8e798c0b796d521b770a89f8ba386ff83f445d3cb8f"
    sha256 cellar: :any,                 arm64_sonoma:  "1a0c985e81fde42d2e439ed3f5d2777b5afaa0215161f14273f2678d7e73099d"
    sha256 cellar: :any,                 sonoma:        "88951415f3f7df7930f82c8219e3ef53b2bf9b10c4c5b6b596a9a2163ae0484f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b956bb4f5589ad686dc2da16184133d2e961f6ae6c8108adf3248d04b30e0f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "573499daf456306582be17f531128f191252a6acb7626d516dade9501dacba9c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78" => :build
  depends_on "pkgconf" => :build

  depends_on "capnp"
  depends_on "gflags"
  depends_on "glog"
  depends_on "leveldb"
  depends_on "lua"
  depends_on "marisa"
  depends_on "opencc"
  depends_on "yaml-cpp"

  resource "lua" do
    url "https://github.com/hchunhui/librime-lua/archive/68f9c364a2d25a04c7d4794981d7c796b05ab627.tar.gz"
    sha256 "3c4a60bacf8dd6389ca1b4b4889207b8f6c0c6a43e7b848cdac570d592a640b5"
  end

  resource "octagram" do
    url "https://github.com/lotem/librime-octagram/archive/dfcc15115788c828d9dd7b4bff68067d3ce2ffb8.tar.gz"
    sha256 "7da3df7a5dae82557f7a4842b94dfe81dd21ef7e036b132df0f462f2dae18393"
  end

  resource "predict" do
    url "https://github.com/rime/librime-predict/archive/920bd41ebf6f9bf6855d14fbe80212e54e749791.tar.gz"
    sha256 "38b2f32254e1a35ac04dba376bc8999915c8fbdb35be489bffdf09079983400c"
  end

  resource "proto" do
    url "https://github.com/lotem/librime-proto/archive/657a923cd4c333e681dc943e6894e6f6d42d25b4.tar.gz"
    sha256 "69af91b1941781be6eeceb2dbdc6c0860e279c4cf8ab76509802abbc5c0eb7b3"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"plugins"/r.name
    end

    args = %W[
      -DBUILD_MERGED_PLUGINS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"rime-plugins")}
      -DENABLE_EXTERNAL_PLUGINS=ON
      -DBUILD_TEST=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "rime_api.h"

      int main(void)
      {
        RIME_STRUCT(RimeTraits, rime_traits);
        return 0;
      }
    CPP

    system ENV.cc, "./test.cpp", "-o", "test"
    system testpath/"test"
  end
end
